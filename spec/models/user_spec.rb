require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "username, email, passwordがあれば有効であること" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "usernameがなければ無効であること" do
      user = build(:user, username: nil)
      expect(user).not_to be_valid
    end
  end
end
