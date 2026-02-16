class ActivityLogsController < ApplicationController

  def create
    @activity_log = current_user.activity_logs.build(activity_log_params)

    if @activity_log.save
      redirect_to top_path, notice: "運動が記録されました！"
    else
      head :unprocessable_entity
    end
  end

  private

  def activity_log_params
    params.require(:activity_log).permit(:exercise_id, :sitting_session_id)
  end
end
