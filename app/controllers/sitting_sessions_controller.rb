class SittingSessionsController < ApplicationController

  before_action :authenticate_user!

  def new
  end

  def create

    @sitting_session = current_user.sitting_sessions.build(session_params)

    if @sitting_session.save
      #座位時間が保存されたら運動をランダムに提案
      @recommended_exercise = Exercise.all.sample

      respond_to do |format|
        #create.turbo_stream.erbを呼び出す
        format.turbo_stream
        #モーダル表示されない場合はshowへ
        format.html { redirect_to sitting_session_path(@sitting_session) }
      end
    end
  end

  end

  def show
  end

  private

  def session_params
    params.require(:sitting_session).permit(:duration, :start_at)
  end
end
