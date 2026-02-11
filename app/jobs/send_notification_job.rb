require "web-push"

class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(sitting_session_id)
    session = SittingSession.find_by(id: sitting_session_id)

    return if session.nil?

    return unless session.in_progress?

    user = session.user
    return if user.endpoint.blank?

    begin
      WebPush.payload_send(
        message: "休憩しましょう！",
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
