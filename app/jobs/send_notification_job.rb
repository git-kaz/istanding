require "web-push"

class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(sitting_session_id)
    session = SittingSession.find_by(id: sitting_session_id)

    return if session.nil?

    # statusがactiveの時だけ通知
    return unless session&.active?

    user = session.user
    return if user.endpoint.blank?

    begin
      WebPush.payload_send(
        message: JSON.generate({
          title: "休憩の時間です！",
          body: "身体を動かしましょう！",
          url: "/?session_id=#{sitting_session_id}"  # タブを閉じてもsession_idを探してmodalを開ける
      }),
        endpoint: user.endpoint,
        p256dh: user.p256dh,
        auth: user.auth,
        vapid: {
          public_key: Rails.application.credentials.dig(:webpush, :public_key),
          private_key: Rails.application.credentials.dig(:webpush, :private_key),
          subject: "mailto:okw.kzk@gmail.com"
        }
      )
      session.update!(notified: true)
    rescue WebPush::ExpiredSubscription, WebPush::InvalidSubscription => e

      user.update(endpoint: nil, p256dh: nil, auth: nil)

    rescue => e
      Rails.logger.error "通信エラー: #{e.message}"

    end
  end
end
