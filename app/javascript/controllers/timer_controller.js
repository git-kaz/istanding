import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="timer"
export default class extends Controller {
    static targets = ["display"]
    connect() {
        this.remainingTime = 0
        this.timer = null
        this.isModalOpen = false

        const params = new URLSearchParams(window.location.search)
        if (params.get('reopen_modal')) {
            this.finish()
            this.isModalOpen = true

            //タイマーに戻った時にURLからreopen_modal=trueを消す
            const newUrl = window.location.pathname
            window.history.replaceState({}, document.title, newUrl)
        }
    }
    //時間セット
    setTime(event) {
        const minutes = event.params.minutes
        //秒数に変換
        //デバッグ用
        this.selectedSeconds = 5
        // this.selectedSeconds = minutes * 60
        this.remainingTime = this.selectedSeconds
        this.updateDisplay()
    }

    start() {
        if (!this.selectedSeconds || this.selectedSeconds <= 0) return
        //既存のタイマーを止める
        this.resetModalFlag()
        this.remainingTime = this.selectedSeconds
        this.startTime = new Date()
        this.updateDisplay()

        //1秒ごとにカウントダウン
        this.timer = setInterval(() => {
            //timerがnilの場合は早期リターン
            if (!this.timer) return
            
            this.remainingTime -= 1
            this.updateDisplay()       
            
            if (this.remainingTime <= 0) {
                //fetch,モーダル表示
                if (!this.isModalOpen) {
                    this.finish()
                    this.isModalOpen = true
                }
            
                this.remainingTime = this.selectedSeconds
                this.updateDisplay()
            } 

        }, 1000)
    }

    stop() {
        if (this.timer) {
            clearInterval(this.timer)
            this.timer = null
        }
    }

    reset() {
        this.stop()              // タイマーを止める
        this.remainingTime = 0   // 残り時間を0にする
        this.updateDisplay()     // 表示を 00:00 に更新する
        this.isModalOpen = false // モーダルフラグも寝かせておく
    }
    
    updateDisplay() {
        const m = Math.floor(this.remainingTime / 60)
        const s = this.remainingTime % 60
        this.displayTarget.textContent = `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
    }
    
    //運動の選択orスキップ後の処理
    async finish() {
        const endTime = new Date()
        const duration = Math.floor((endTime - this.startTime) / 1000)

        const recordedStartTime = this.startTime
        this.startTime = new Date()

        //RailsのAPIにデータを飛ばす
        const response = await fetch("/sitting_sessions", {
            method: "POST",
            headers: {
                "Accept": "text/vnd.turbo-stream.html",
                "Content-Type": "application/json",
                "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({
                sitting_session: {
                    duration: duration,
                    start_at: recordedStartTime
                }
            })
        })

        if (response.ok) {
            const streamMessage = await response.text()
            Turbo.renderStreamMessage(streamMessage) // 4. これが重要！届いたTurbo Streamを実行する
        }
    }

    resetModalFlag() {
        this.stop()
        this.isModalOpen = false
    }

    closeModal() {
        this.resetModalFlag()
        document.getElementById('modal_container').innerHTML = ''
    }
}
