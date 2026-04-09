require 'rails_helper'

RSpec.describe SendNotificationJob, type: :job do
  let(:user) { create(:user) }

  describe "#perform_later" do
    it "ジョブが正しくキューに追加されること" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        SendNotificationJob.perform_later(user.id)
      }.to have_enqueued_job(SendNotificationJob).with(user.id).on_queue("default")
    end

    it "セッションの終了時にジョブが予約されること" do
      sitting_session = create(:sitting_session, user: user, start_at: Time.current, duration: 30)
      expect {
        SendNotificationJob.set(wait_until: sitting_session.notify_at).perform_later(sitting_session.id)
      }.to have_enqueued_job(SendNotificationJob)
      .with(sitting_session.id)
      .at(sitting_session.notify_at)
    end
  end
end
