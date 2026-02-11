class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(sitting_session_id)
    session = SittingSession.find_by(id: sitting_session_id)
    
    return if session.nil?

    return unless session.in_progress?

    user = session.user
    return if user.endpoint.blank?

    begin
      Webpush.payload_send(
        message: "休憩しましょう！",
        endpoint: user.endpoint,
        p256dh: user.p256dh,
        auth: user.auth,
        vapid: {
          public_key: Rails.application.credentials.dig(:vapid, :public_key),
          private_key: Rails.application.credentials.dig(:vapid, :private_key),
          subject: "mailto:okw.kzk@gmail.com"
        }
      )
    rescue Webpush::ExpiredSubscription, Webpush::InvalidSubscription => e
      
      user.update(endpoint: nil, p256dh: nil, auth: nil)
    
    rescue => e
      Rails.logger.error "通信エラー: #{e.message}"
      
    end
  end
end
