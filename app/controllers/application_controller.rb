class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected
  # ログイン後のタイマー画面への遷移を共通化
  def after_sign_in_path_for(resource)
    new_sitting_session_path
  end
end
