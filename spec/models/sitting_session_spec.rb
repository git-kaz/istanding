require 'rails_helper'

RSpec.describe SittingSession, type: :model do
let!(:user) { create(:user) }

  describe "コールバック" do
    it "新しいセッションの作成時に既存のセッションが終了すること" do
      old_session = create(:sitting_session, user: user, status: :active)

      expect{
        create(:sitting_session, user: user, status: :active)
    }.to change{ old_session.reload.status }.from("active").to("cancelled")
    end
  end

  describe "バリデーション" do
    it "start_atがなければ無効であること" do
      sitting_session = build(:sitting_session, user: user, start_at: nil)
      expect(sitting_session).not_to be_valid
    end

    it "デフォルトのstatusはactiveであること" do
      sitting_session = create(:sitting_session, user: user)
      expect(sitting_session.status).to eq("active")
    end
  end
end
