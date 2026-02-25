require 'rails_helper'

RSpec.describe SendNotificationJob, type: :job do
  let(:user){ create(:user) }

  describe "#perform_later" do
    it "ジョブが正しくキューに追加されること" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        SendNotificationJob.perform_later(user.id)
      }.to have_enqueued_job(SendNotificationJob).with(user.id).on_queue("default")
    end
  end

end
