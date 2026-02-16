class ActivityLogsController < ApplicationController

  def create
    @activity_log = current_user.activity_logs.build(activity_log_params)

    if @activity_log.save
      #保存後に運動回数を更新(turbo)
      render turbo_stream: turbo_stream.replace(
        "exercise_count",
        partial: "top/exercise_count",
        locals: { exercise_count: current_user.today_exercise_count }
      )
    else
      head :unprocessable_entity
    end
  end

  private

  def activity_log_params
    params.require(:activity_log).permit(:exercise_id, :sitting_session_id)
  end
end
