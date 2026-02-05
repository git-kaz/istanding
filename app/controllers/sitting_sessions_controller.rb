class SittingSessionsController < ApplicationController

  before_action :authenticate_user!

  def new
  end

  def create

    @sitting_session = current_user.sitting_sessions.build(session_params)

    if @sitting_session.save
      #座位時間が保存されたら運動をランダムに提案
      @recommended_exercise = Exercise.all.sample

      render json: {
        status: :created,
        exercise: @recommended_exercise
      }
    else
      render json: {
        status: :unprocessable_entity,
      }, status: :unprocessable_entity
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
