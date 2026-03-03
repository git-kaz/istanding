import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

const DEBUG_MODE = false; // デバッグ時に秒数を短縮するかどうか
const AUTO_CLOSE_MS = 600000; // 10分

export default class extends Controller {
    static targets = ["display", "circle", "durationInput"]

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

    setTime(event) {
        const minutes = event.params.minutes
        this.selectedSeconds = DEBUG_MODE ? 5 : minutes * 60
        this.remainingTime = this.selectedSeconds

        if (this.hasDurationInputTarget) {
            this.durationInputTarget.value = minutes
            console.log("Set durationInput to:", this.durationInputTarget.value) // デバッグ用
    } else {
        console.error("durationInputTarget not found!") // 見つからない場合のエラー
        }
        this.updateDisplay()
        this.updateCircle()
    }

    start() {

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
                this.finish()
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

    stop() {
        if (this.timer) {
            clearInterval(this.timer)
            this.timer = null
        }
    }

    reset() {
        this.stop()
        this.clearAutoCloseTimer()
        this.remainingTime = 0
        this.isModalOpen = false
        this.updateDisplay()
        this.clearModalUI()
        this.updateCircle()
    }

    resetState() {
        this.stop()
        this.clearAutoCloseTimer()
        this.isModalOpen = false
        this.clearModalUI()
    }

    showSessionModal() {
        if (this.isModalOpen) return
        this.isModalOpen = true

        
        // 放置対策：一定時間後に自動で閉じる
        this.autoCloseTimer = setTimeout(() => {
            if (this.isModalOpen) this.closeModal()
        }, AUTO_CLOSE_MS)
    }

   async finish() {
    this.stop()
    this.clearAutoCloseTimer()
    this.remainingTime = 0
    this.updateDisplay()
    this.clearModalUI()
    this.updateCircle()

    if (!this.startTime) return

    this.actualDuration = Math.floor((new Date() - this.startTime) / 1000)

    const response = await fetch("/sitting_sessions/finish_current", {
        method: "PATCH",
        headers: {
            "Accept": "text/vnd.turbo-stream.html",
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ duration: this.actualDuration })
    })

    if (response.ok) {
        //Railsから返ってきた turbo_stream（モーダル表示）を実行
        const streamMessage = await response.text()
        Turbo.renderStreamMessage(streamMessage)
        
        this.resetState()
    }
}

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