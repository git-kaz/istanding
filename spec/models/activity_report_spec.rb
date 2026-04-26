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
    sessions = user.sitting_sessions
                    .where(created_at: period)
                    .group("DATE(created_at)")
                    .sum(:duration)
                    .values.sum

    # ActivityReportを作成
    report = ActivityReport.new(period, sessions, 0)

    # 合計が1.0時間(3600秒)になっているか
    expect(report.total_duration_hours).to eq 1.0
  end


  it "期間内の運動回数を返すこと" do
    # テストデータを2つ作成
    create(:activity_log, user: user, created_at: period.begin)
    create(:activity_log, user: user, created_at: period.end)

    logs = user.activity_logs
                    .where(created_at: period)
                    .group("DATE(created_at)")
                    .count
                    .values.sum

    report = ActivityReport.new(period, 0, logs)

    expect(report.exercise_count).to eq 2
  end
end
