class ActivityReport
  attr_reader :period, :total_duration_hours, :exercise_count, :active_days_count, :average_duration_hours

  # 全てハッシュ化するために計算結果はインスタンスに保存
  def initialize(period, sessions, logs)
    @period = period

    # 座位時間の計算
    total_seconds = if sessions.respond_to?(:sum) && !sessions.is_a?(Array)
                      sessions.sum(:duration)
    else
                      sessions.sum { |s| s.duration || 0 }
    end
    @total_duration_hours = (total_seconds  / 3600.0).round(1)
    # 運動回数の計算
    @exercise_count = logs.respond_to?(:count) ? logs.count : logs.size

    # 活動日数の計算(リレーションか配列化によって取得方法を変える)
    session_dates = sessions.respond_to?(:pluck) ? sessions.pluck(:created_at).map(&:to_date) : sessions.map { |s| s.created_at.to_date }
    log_dates = logs.respond_to?(:pluck) ? logs.pluck(:created_at).map(&:to_date) : logs.map { |l| l.created_at.to_date }
    @active_days_count = (session_dates + log_dates).uniq.count

    # 平均座位時間の計算
    @average_duration_hours = @active_days_count.zero? ? 0.0 : (@total_duration_hours / @active_days_count).round(1)
  end

  # 日別レポートをまとめて生成するクラスメソッド
  def self.generate_daily_reports(user, date_range)
    # N+1クエリを避けるために期間ないのデータを一気に取得
    all_sessions = user.sitting_sessions.where(created_at: date_range).group_by { |s| s.created_at.to_date }
    all_logs = user.activity_logs.where(created_at: date_range).group_by { |l| l.created_at.to_date }

    date_range.map do |date|
      new(
        date.all_day,
        all_sessions[date] || [],
        all_logs[date] || []
      )
    end
  end

  # 週別や月別のレポートを作成するクラスメソッド
  def self.generate_by_period(user, periods)
    periods.map do |range|
      new(
        range,
        user.sitting_sessions.where(created_at: range),
        user.activity_logs.where(created_at: range)
      )
    end
  end

  # ハッシュを作るメソッド
  def to_hash
    {
      total_duration_hours: total_duration_hours,
      exercise_count: exercise_count,
      active_days_count: @active_days_count,
      average_duration_hours: @average_duration_hours,
      date_label: date_label
    }
  end

  private
  # データ範囲のラベルを生成
  def date_label
    # 日別なら4/8, 週別なら4/1~の様に返す
    if period.begin == period.end.beginning_of_day
      period.begin.strftime("%-m/%-d")
    else
      "#{period.begin.strftime("%-m/%-d")}~"
    end
  end
end
