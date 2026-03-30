class TopController < ApplicationController
  before_action :authenticate_user!

  def index
    # 1日の座位時間合計
    @total_seconds = current_user.today_total_sitting_seconds
    # 1日の運動回数
    @exercise_count = current_user.today_exercise_count
    # タイマーにnotify_atを渡すための変数
    @active_session = current_user.sitting_sessions.active.last

    if params[:reopen_modal] == "true"
      @exercises = Exercise.order("RANDOM()").limit(3)
    end
  end
end
