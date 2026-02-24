require 'rails_helper'

RSpec.describe SittingSession, type: :model do
let!(:user) { create(:user) }

  describe "バリデーション" do
    it "開始時間がなければ無効であること" do
      session = build(:sitting_session, start_at: nil)
      expect(session).not_to be_valid
    end
  end

  describe "アソシエーション" do
    it "Userモデルに属していること" do
      t = SittingSession.reflect_on_association(:user)
      expect(t.macro).to eq :belongs_to
    end
  end
end
