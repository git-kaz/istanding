require 'rails_helper'

RSpec.describe "SittingSessions", type: :system do
  let!(:user) { create(:user) }
  let!(:exercise) { create(:exercise, name: "肩甲骨ストレッチ") }

  before do
     driven_by(:rack_test) # JSなしで動かす

    # ログイン済みの状態にする（共通化している場合はそのメソッドを呼ぶ）
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

end
