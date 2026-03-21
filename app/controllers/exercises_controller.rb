class ExercisesController < ApplicationController
  def index
  end

  def show
    @exercise = Exercise.find(params[:id])
    @health_tip = HealthTip.random_tips
  end

  def random
    @exercise = Exercise.order("RANDOM()").first
    redirect_to exercise_path(@exercise)
  end
end
