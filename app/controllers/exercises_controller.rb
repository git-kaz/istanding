class ExercisesController < ApplicationController
  def index
  end

  def show
    @exercise = Exercise.find(params[:id])
    @tips_index, @health_tip = HealthTip.random_tips

    @ogp_url = ogp_image_url(index: @tips_index)

    set_meta_tags og: {
      title: "iStanding - 座りすぎを防ぐタイマーアプリ",
      image: @ogp_url,
      type: "article"
    },
    twitter: {
      card: "summary_large_image",
      image: @ogp_url
    }
  end

  def random
    @exercise = Exercise.active.order("RANDOM()").first
    redirect_to exercise_path(@exercise)
  end
end
