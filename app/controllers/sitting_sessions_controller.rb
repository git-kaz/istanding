class SittingSessionsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    minutes = params.dig(:sitting_session, :duration).to_i
    @sitting_session = current_user.sitting_sessions.build(
      duration: minutes,
      status: :active
    )

    if @sitting_session.save

      # タイマー終了時に通知jobを予約する
      SendNotificationJob.set(wait_until: @sitting_session.notify_at)
                          .perform_later(@sitting_session.id)
      # notify_atをJSに渡す
      render json: { notify_at: @sitting_session.notify_at.iso8601 }
    end
  end

  # タイマー終了時にduration更新とステータス変更
  def finish_current
    @sitting_session = current_user.sitting_sessions.active.last
    return head :not_found unless @sitting_session

    # 休憩するで早期に終了したらdurationを更新
    @sitting_session.update(duration: (Time.current - @sitting_session.start_at).to_i)

    # 自由な運動を記録するためにotherカテゴリのexercise_idを渡す
    @other_exercise = Exercise.find_by(category: :other)

    # ダメージを計算
    current_user.take_damage(@sitting_session.duration)

    # 休憩するボタンで終了した時に通知を送らないようにする
    @sitting_session.completed!

    # N+1を防ぐために一回のアクセスで3つの画像を取得
    @exercises = Exercise.order("RANDOM()").limit(3).includes(image_attachment: :blob)
    respond_to do |format|
      format.turbo_stream
    end
  end

  # リセットボタン用
  def reset_current
    @sitting_session = current_user.sitting_sessions.active.last
    return head :not_found unless @sitting_session

    @sitting_session.cancelled!
  end

  def subscribe
    auth_key = params[:subscription][:keys]

    if current_user.update(
      endpoint: params[:subscription][:endpoint],
      p256dh: auth_key[:p256dh],
      auth: auth_key[:auth]
    )
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def session_params
    params.require(:sitting_session).permit(:duration, :start_at)
  end
end
