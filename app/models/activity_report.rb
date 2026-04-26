class ActivityReport
  attr_reader :period, :total_duration_hours, :exercise_count, :date_label

  # 全てハッシュ化するために計算結果はインスタンスに保存
  def initialize(period, sessions, logs)
    @period = period

    # 座位時間の計算
    total_seconds = sessions
    @total_duration_hours = (total_seconds  / 3600.0).round(1)

    # 運動回数の計算
    @exercise_count = logs
  end

  # 日別レポートをまとめて生成するクラスメソッド
  def self.generate_daily_reports(user, date_range)
    # N+1クエリを避けるために期間内のデータを一気に取得
    all_sessions = user.sitting_sessions
                        .where(created_at: date_range)
                        .group("DATE(created_at)")
                        .sum(:duration)

    all_logs = user.activity_logs
                    .where(created_at: date_range)
                    .group("DATE(created_at)")
                    .count

    # TimeWithZoneはイテレートできないのでDateに変換
    date_only_range = date_range.begin.to_date..date_range.end.to_date

    date_only_range.map do |date|
      new(
        date.all_day,
        all_sessions[date] || 0,
        all_logs[date] || 0
        )
    end
  end

  # 週別や月別のレポートを作成するクラスメソッド
  def self.generate_by_period(user, periods)
    # 　全期間をまとめて取得
    full_range = periods.first.begin..periods.last.end

    session_by_date = user.sitting_sessions
                          .where(created_at: full_range)
                          .group("DATE(created_at)")
                          .sum(:duration)

    log_by_date = user.activity_logs
                       .where(created_at: full_range)
                       .group("DATE(created_at)")
                       .count

    # 各periodのデータを振り分けてレポートを生成
    periods.map do |range|
      period_sessions = session_by_date.select { |date, _| range.cover?(date) }.values.sum
      period_logs = log_by_date.select { |date, _| range.cover?(date) }.values.sum
      new(range, period_sessions, period_logs)
    end
  end

  # 連続日数を計算する（ストリーク）
  def self.calculate_streak(user)
    # 全ての活動日を新しい順で取得して日付に変換
    active_dates = user.activity_logs
                   .select("DATE(created_at) as date")
                   .distinct
                   .order("DATE(created_at) DESC")
                   .map(&:date)

    return 0 if active_dates.empty?

    streak = 0
    # 今日または昨日からカウント開始
    current_date = active_dates.first == Date.current ? Date.current : (Date.current - 1.day)

    # 最後の活動日が昨日より前ならストリークは0
    return 0 if active_dates.first < (Date.current - 1.day)

    active_dates.each do |date|
      if date == current_date
        streak += 1
        current_date -= 1.day
      elsif date < current_date
        break
      end
    end
    streak
  end

  # ハッシュを作るメソッド
  def to_hash
    {
      total_duration_hours: total_duration_hours,
      exercise_count: exercise_count,
      date_label: date_label
    }
  end

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
