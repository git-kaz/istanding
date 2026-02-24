require 'rails_helper'

RSpec.describe Exercise, type: :model do
  describe "バリデーション" do
    it "nameとcaloriesがあれば有効であること" do
      exercise = build(:exercise)
      expect(exercise).to be_valid
    end

    it "nameがなければ無効であること" do
      exercise = build(:exercise, name: nil)
      expect(exercise).not_to be_valid
    end
end
