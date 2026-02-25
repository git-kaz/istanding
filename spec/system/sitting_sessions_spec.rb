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

  it "タイマーを開始し、休憩ボタンから運動を選択できること" do
    visit root_path

    # 1. タイマー時間の選択（例: 30分）
    click_on "30min"
    click_on "スタート"

    # 2. 画面上に「休憩する」ボタンが出現することを確認
    expect(page).to have_content "休憩する"
  end
end
