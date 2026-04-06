class ActivityReport
  attr_reader :period, :sitting_sessions, :activity_logs

  def initialize(period, sitting_sessions = SittingSession.none, activity_logs = ActivityLog.none)
    @period = period
    @sitting_sessions = sitting_sessions
    @activity_logs = activity_logs
  end

  def total_duration_hours
    #秒を時間に変換して小数点第一位まで表示
    (sitting_sessions.sum(:duration) / 3600.0).round(1)
  end

  # 運動回数をカウント
  def exercise_count
    activity_logs.count
  end

  def active_days_count
    session_dates = sitting_sessions.pluck(:created_at).map(&:to_date)
    log_dates = activity_logs.pluck(:created_at).map(&:to_date)
    (session_dates + log_dates).uniq.count
  end

  def average_duration_hours
    return 0.0 if active_days_count.zero?

    (total_duration_hours / active_days_count).round(1)
  end
end

