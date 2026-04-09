require 'rails_helper'

RSpec.describe ActivityReport, type: :model do
  let(:user) { create(:user) }
  let(:period) { Time.zone.now.all_day } # 今日一日

  before do
    # 30分(1800秒)のセッションを2つ
    create(:sitting_session, user: user, duration: 1800, created_at: Time.zone.now)
    create(:sitting_session, user: user, duration: 1800, created_at: Time.zone.now)
  end

  it "指定された期間の合計座位時間を時間単位で正しく表示すること" do
    # ログを期間で絞り込んで準備
    sessions = user.sitting_sessions.where(created_at: period)

    # ActivityReportを作成
    report = ActivityReport.new(period, sessions, ActivityLog.none)

    # 合計が1.0時間(3600秒)になっているか
    expect(report.total_duration_hours).to eq 1.0
  end

  it "期間内のユニークな活動日数をカウントすること" do
    # 同日に2つのセッション
    create(:sitting_session, user: user, created_at: Time.zone.now)
    create(:sitting_session, user: user, created_at: Time.zone.now)

    sessions = user.sitting_sessions.where(created_at: period)
    report = ActivityReport.new(period, sessions, ActivityLog.none)

    expect(report.active_days_count).to eq 1
  end

  it "ログが0の時、平均座位時間に0.0を返すこと" do
    empty_logs = user.sitting_sessions.none
    report = ActivityReport.new(period, empty_logs, ActivityLog.none)

    expect(report.average_duration_hours).to eq 0.0
  end

  it "期間内の運動回数を返すこと" do
    # テストデータを2つ作成
    create(:activity_log, user: user, created_at: period.begin)
    create(:activity_log, user: user, created_at: period.end)

    logs = user.activity_logs.where(created_at: period)
    report = ActivityReport.new(period, SittingSession.none, logs)

    expect(report.exercise_count).to eq 2
  end
end
