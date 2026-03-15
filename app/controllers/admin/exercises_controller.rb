class Admin::ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise, only: %i[edit update destroy]

  def index
    @exercises = policy_scope(Exercise)
    authorize Exercise
  end

  def new
    @exercise = Exercise.new
    authorize @exercise
  end

  def create
    @exercise = Exercise.new(exercise_params)
    authorize @exercise

    if @exercise.save
      redirect_to admin_exercises_path, notice: "Exerciseを追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @exercise
  end

  def update
    authorize @exercise
    if @exercise.update(exercise_params)
      redirect_to admin_exercises_path, notice: "Exerciseを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @exercise
    @exercise.destroy
    redirect_to admin_exercises_path, notice: "Exerciseを削除しました"
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:name, :instructions, :category, :image, :benefits)
  end
end
