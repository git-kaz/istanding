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
    @activity_logs = current_user.activity_logs.includes(:exercise).order(created_at: :desc).limit(5)
    # 7日間(日別)：月曜始まり
    this_monday = Date.current.beginning_of_week(:monday).end_of_day
    @daily_reports = ActivityReport.generate_daily_reports(current_user, this_monday..(this_monday + 6.days)).map(&:to_hash)

    # 8週間（週別）：月〜日曜
    weekly_periods = (0..7).map { |i| i.weeks.ago.all_week(:monday) }.reverse
    @weekly_reports = ActivityReport.generate_by_period(current_user, weekly_periods).map(&:to_hash)

    # 6か月（月別）：月単位
    monthly_periods = (0..5).map { |i| i.months.ago.all_month }.reverse
    @monthly_reports = ActivityReport.generate_by_period(current_user, monthly_periods).map(&:to_hash)

    # ヒートマップ（直近140日）
    base_date = 140.days.ago.to_date.beginning_of_week(:monday)
    heatmap_range = (base_date..Date.current.end_of_day)
    @heatmap_reports = ActivityReport.generate_daily_reports(current_user, heatmap_range).map(&:to_hash)

    # ストリーク（連続日数）
    @current_streak = ActivityReport.calculate_streak(current_user)

    # 　今月の運動回数
    @this_month_count = current_user.activity_logs.where(created_at: Time.current.all_month).count
  end

  private

  def activity_log_params
    params.require(:activity_log).permit(:exercise_id, :sitting_session_id, :note, :duration_minutes)
  end
end
