require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  let(:user) { create(:user) }
  let(:exercise) { create(:exercise) }
  let(:other_exercise) { create(:exercise, :other) }

  context ' 自由運動(category: other)の場合' do
    it "noteがない場合は無効であること" do
      log = build(:activity_log, user: user, exercise: other_exercise, note: nil)
      expect(log).not_to be_valid
      # expect(log.errors[:note]).to include("を入力してください")
    end

    it "運動時間がない場合は無効であること" do
      log = build(:activity_log, user: user, exercise: other_exercise, duration_minutes: nil)
      expect(log).not_to be_valid
      # expect(log.errors[:duration]).to include("を入力してください")
    end
  end

  context "通常の運動の場合" do
    it "noteがなくても有効であること" do
      log = build(:activity_log, user: user, exercise: exercise, note: nil)
      expect(log).to be_valid
    end
  end
end
