class ActivityLogsController < ApplicationController
  before_action :require_login

  def new
    @exercise = Exercise.find(params[:exercise_id])
    @activity_log = current_user.activity_logs.build(exercise: @exercise)
  end

  def create
    @activity_log = current_user.activity_logs.build(activity_log_params)

    # 自由運動を選択したが時間が殻の場合は新規作成にリダイレクト
    if @activity_log.exercise.category == "other" && @activity_log.duration_minutes.nil?
      redirect_to new_activity_log_path(exercise_id: @activity_log.exercise_id)
      return
    end

    if @activity_log.save
      # modelのコールバック（before_create）でHP回復している
      @activity_log.sitting_session&.completed!
      redirect_to root_path, notice: "運動を記録しました！", status: :see_other
    else
      # 　自由運動のバリデーション落ちは内容を保持
      if @activity_log.exercise.category == "other"
        @exercise = @activity_log.exercise
        render :new, status: :unprocessable_entity
      else
      # 通常の運動を選択した場合はリダイレクト
      redirect_back fallback_location: root_path,
                    alert: "記録に失敗しました: #{@activity_log.errors.full_messages.join(', ')}"
      end
    end
  end

  def index
    @daily_sitting = current_user.daily_sitting_hours(days: 7)
    @daily_exercises = current_user.daily_exercise_counts(days: 7)
    @activity_logs = current_user.activity_logs
                                 .includes(:exercise)
                                 .order(created_at: :desc)
                                 .limit(5)
  end

  private

  def activity_log_params
    params.require(:activity_log).permit(:exercise_id, :sitting_session_id, :note, :duration_minutes)
  end
end
