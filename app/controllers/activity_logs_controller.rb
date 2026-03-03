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

  private

  def activity_log_params
    params.require(:activity_log).permit(:exercise_id, :sitting_session_id)
  end
end
