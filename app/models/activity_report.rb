class ActivityReport
  attr_reader :period, :sitting_sessions, :activity_logs

  def initialize(period, sitting_sessions = SittingSession.none, activity_logs = ActivityLog.none)
    @period = period
    @sitting_sessions = sitting_sessions
    @activity_logs = activity_logs
  end

  def total_duration_hours
    # 秒を時間に変換して小数点第一位まで表示
    (sitting_sessions.sum(:duration) / 3600.0).round(1)
  end

  # 運動回数をカウント
  def exercise_count
    activity_logs.count
  end

  # 活動日数をカウント
  def active_days_count
    session_dates = sitting_sessions.pluck(:created_at).map(&:to_date)
    log_dates = activity_logs.pluck(:created_at).map(&:to_date)
    (session_dates + log_dates).uniq.count
  end

  # 平均座位時間を計算
  def average_duration_hours
    return 0.0 if active_days_count.zero?

    (total_duration_hours / active_days_count).round(1)
  end

  # 日別レポートをまとめて生成するクラスメソッド
  def self.generate_daily_reports(user, date_range)
    # N+1クエリを避けるために期間ないのデータを一気に取得
    all_sessions = user.sitting.sessions.where(created_at: date_range).group_by { |s| s.created_at.to_date }
    all_logs = user.activity_logs.where(created_at: date_range).group_by { |l| l.created_at.to_date }

    dare_range.map do |date|
      new(
        date.all_day,
        all_sessions[date] || SittingSession.none,
        all_logs[date] || ActivityLog_none
      )
    end
  end

  # 週別や月別のレポートを作成するクラスメソッド
  def self.generate_by_period(user, periods)
    periods.map do |range|
      new(
        range,
        user.sitting_sessions.where(created_at: range),
        user.activity.logs.where(created_at: range)
      )
    end
  end
end
