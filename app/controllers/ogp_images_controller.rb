class OgpImagesController < ApplicationController
  def show
    index = params[:index].to_i
    text = HealthTip::TIPS[index]
    image = OgpCreator.build(text)

    send_data image.to_blob, type: "image/png", disposition: "inline"
  end
end
