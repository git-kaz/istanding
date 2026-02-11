class SittingSessionsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    @sitting_session = current_user.sitting_sessions.build(session_params)

    if @sitting_session.save
      # 座位時間が保存されたら運動をランダムに提案
      @exercises = Exercise.order("RANDOM()").limit(3)
      # デバッグ用
      SendNotificationJob.set(wait_until: Time.current + 5.seconds)
                         .perform_later(@sitting_session.id)
      # タイマー終了時に通知jobを予約する
      # SendNotificationJob.set(wait_until: Time.current +@sitting_session.end_time)
      #                    .perform_later(@sitting_session.id)

      respond_to do |format|
        # create.turbo_stream.erbを呼び出す
        format.turbo_stream
        # モーダル表示されない場合はshowへ
        format.html { redirect_to sitting_session_path(@sitting_session) }
      end
    end
  end

  def show
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
