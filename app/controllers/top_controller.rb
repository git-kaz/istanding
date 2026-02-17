class TopController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_seconds = 7200 # current_user.today_total_sitting_seconds
    @percentage = 25 # current_user.sitting_progress_percentage
    @exercise_count = current_user.today_exercise_count

    @sitting_session = current_user.sitting_sessions.new
  end
end
