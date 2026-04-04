class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_default_meta_tags

  include Pundit::Authorization

  def set_default_meta_tags
    set_meta_tags(
      og: {
        title: "iStanding - 座りすぎを防ぐタイマーアプリ",
        description: "座りすぎは喫煙と同等のリスク。定期的な休憩習慣をサポートします。",
        image: "https://istanding.jp/ogp.png"
      },
      twitter: {
        card: "summary_large_image",
        image: "https://istanding.jp/ogp.png"
      }
    )
  end

  protected
  # ログイン後のタイマー画面への遷移を共通化
  def after_sign_in_path_for(resource)
    root_path
  end

  def require_login
    unless user_signed_in?
      redirect_to root_path
    end
  end
end
