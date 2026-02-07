import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="timer"
export default class extends Controller {
    static targets = ["display"]
    connect() {
        //開始時間
        this.startTime = new Date()
        this.startTimer()
    }
    
    startTimer() {
        this.timer = setInterval(() => {

        }, 1000)
    }
    //運動の選択orスキップ後の処理
    async finish(event) {
        const endTime = new Date()
        const duration = Math.floor((endTime - this.startTime) / 1000)

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
                    start_at: this.startTime
                }
            })
        })

        if (response.ok) {
            const streamMessage = await response.text()
            Turbo.renderStreamMessage(streamMessage) // 4. これが重要！届いたTurbo Streamを実行する
        }
    }
}
