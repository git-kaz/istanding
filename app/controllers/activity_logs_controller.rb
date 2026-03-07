class ActivityLogsController < ApplicationController
 def create
  @activity_log = current_user.activity_logs.build(
    activity_log_params.merge(sitting_session: current_user.sitting_sessions.active.last)
  )

    if @activity_log.save
      @activity_log.sitting_session&.completed!
      redirect_to root_path, notice: "運動を記録しました！", status: :see_other
    else
      redirect_back fallback_location: root_path,
                    alert: "記録に失敗しました: #{@activity_log.errors.full_messages.join(', ')}"
    end
  end

  def index
    @daily_sitting = current_user.daily_sitting_hours(days: 7)
    @daily_exercises = current_user.daily_exercise_counts(days: 7)
    @activity_logs = current_user.activity_logs
                                 .includes(:exercise)
                                 .order(created_at: :desc)
                                 .limit(5)
  end

  private

  def activity_log_params
    params.require(:activity_log).permit(:exercise_id, :sitting_session_id)
  end
end
