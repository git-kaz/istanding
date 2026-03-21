class ExercisesController < ApplicationController
  def index
  end

  def show
    @exercise = Exercise.find(params[:id])
    @health_tip = HealthTip.random_tips
  end
end
