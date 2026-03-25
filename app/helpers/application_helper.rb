module ApplicationHelper
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
      config.draw "text 0, -60 '#{prepare_text(text)}'"
    end
    image
  end

  # 18文字で改行
  def self.prepare_text(text)
    text.scan(/.{1,18}/).join("\n")
  end
end
