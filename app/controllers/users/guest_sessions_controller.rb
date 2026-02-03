class Users::GuestSessionsController < ApplicationController
  def create
    user = User.guest
    sign_in user
    redirect_to new_sitting_session_path, notice: "ゲストユーザーとしてログインしました。"
  end
end
