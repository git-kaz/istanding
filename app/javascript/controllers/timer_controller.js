import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

const DEBUG_MODE = true; // デバッグ時に秒数を短縮するかどうか
const AUTO_CLOSE_MS = 600000; // 10分

export default class extends Controller {
    static targets = ["display", "circle"]

    connect() {
        this.remainingTime = 0
        this.selectedSeconds = 0
        this.timer = null
        this.isModalOpen = false
        this.autoCloseTimer = null // 自動閉鎖用タイマー

        if (this.hasCircleTarget) {
            const radius = this.circleTarget.r.baseVal.value
            this.circumference = 2 * Math.PI * radius
            this.circleTarget.style.strokeDasharray = `${this.circumference} ${this.circumference}`
            this.circleTarget.style.strokeDashoffset = 0
        }

        const params = new URLSearchParams(window.location.search)
        if (params.get('reopen_modal')) {
            this.showSessionModal()
            // URLからパラメータを削除
            const newUrl = window.location.pathname
            window.history.replaceState({}, document.title, newUrl)
        }
    }

    // 1. 設定：時間セット
    setTime(event) {
        const minutes = event.params.minutes
        this.selectedSeconds = DEBUG_MODE ? 5 : minutes * 60
        this.remainingTime = this.selectedSeconds
        this.updateDisplay()
        this.updateCircle()
    }

    // 2. 実行：タイマー開始
    start() {
        if (!this.selectedSeconds || this.selectedSeconds <= 0) return

        this.resetState() // 全てをクリアしてから開始
        this.remainingTime = this.selectedSeconds
        this.startTime = new Date()
        this.updateDisplay()
        this.updateCircle()

        this.runTimer()
    }

    runTimer() {
        this.timer = setInterval(() => {
            if (!this.timer) return
            
            this.remainingTime -= 1
            this.updateDisplay()       
            this.updateCircle()
            
            if (this.remainingTime <= 0) {
                this.stop()
                this.showSessionModal()
            } 
        }, 1000)
    }

    updateCircle() {
        if (!this.hasCircleTarget) return

        // 1分間(60秒)で1週する
        const currentSecondInMinutes = this.remainingTime % 60
        const displaySeconds = (currentSecondInMinutes === 0 && this.remainingTime > 0) ? 60 : currentSecondInMinutes

        const offset = this.circumference * (1 - displaySeconds / 60)

        this.circleTarget.style.strokeDashoffset = offset
    }

    // 3. 制御：停止・リセット
    stop() {
        if (this.timer) {
            clearInterval(this.timer)
            this.timer = null
        }
    }

    // 全てをクリアする（リセットボタン等で使用）
    reset() {
        this.stop()
        this.clearAutoCloseTimer()
        this.remainingTime = 0
        this.isModalOpen = false
        this.updateDisplay()
        this.clearModalUI()
    }

    // 内部的な状態リセット（start時などに使用）
    resetState() {
        this.stop()
        this.clearAutoCloseTimer()
        this.isModalOpen = false
        this.clearModalUI()
    }

    // 4. 通信：セッション終了と保存
    showSessionModal() {
        if (this.isModalOpen) return
        this.isModalOpen = true

        this.finish() // サーバーに保存

        // 放置対策：一定時間後に自動で閉じる
        this.autoCloseTimer = setTimeout(() => {
            if (this.isModalOpen) this.closeModal()
        }, AUTO_CLOSE_MS)
    }

    async finish() {
        const recordedStartTime = this.startTime || new Date()
        const duration = Math.floor((new Date() - recordedStartTime) / 1000)

        // 次の計測に備えて開始時刻をリセット
        this.startTime = new Date()

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
            Turbo.renderStreamMessage(streamMessage)
        }
    }

    // 5. UI操作
    closeModal() {
        this.resetState()
        this.clearModalUI()
    }

    clearModalUI() {
        const container = document.getElementById('modal_container')
        if (container) container.innerHTML = ''
    }

    clearAutoCloseTimer() {
        if (this.autoCloseTimer) {
            clearTimeout(this.autoCloseTimer)
            this.autoCloseTimer = null
        }
    }

    updateDisplay() {
        const m = Math.floor(this.remainingTime / 60)
        const s = this.remainingTime % 60
        this.displayTarget.textContent = `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
    }
}