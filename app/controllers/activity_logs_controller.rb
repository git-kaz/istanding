class ActivityLogsController < ApplicationController
  def create
   @sitting_session = current_user.sitting_sessions.active.last
   @active_log = ActivityLog.new(activity_log_params)

    if @active_log.save

      @sitting_session.completed!
      redirect_to root_path, notice: "運動を記録しました！", status: :see_other
    else
      redirect_to root_path, alert: "運動の記録に失敗しました。", status: :see_other
    end
  end

  private

  def activity_log_params
    params.require(:activity_log).permit(:exercise_id, :sitting_session_id)
  end
end
