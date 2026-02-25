require 'rails_helper'

RSpec.describe "ログイン機能", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { create(:user) }

  it "ユーザーがログインできること" do
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    expect(page).to have_current_path root_path
  end
end
