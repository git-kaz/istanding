class OgpCreator
  require "mini_magick"

  # 背景画像パス
  BASE_IMAGE_PATH = Rails.root.join("app/assets/images/iStanding.png")
  # フォントパス
  FONT = Rails.root.join("app/assets/fonts/keifont.ttf")

  def self.build(text)
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)

    image.combine_options do |config|
      config.font FONT
      config.fill "#333"
      config.gravity "Center"
      config.pointsize 45
      config.interline_spacing 20
      config.draw "text 0, -40 '#{text}'"
    end
    image
  end
end
