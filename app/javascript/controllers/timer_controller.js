import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

const AUTO_CLOSE_MS = 600000; // 10分

export default class extends Controller {
    static targets = ["display", "circle", "durationInput", "startButton", "breakButton"]

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

        // パターン1: 新規タブで開いた場合（URLパラメータ）
        const params = new URLSearchParams(window.location.search)
        if (params.get('session_id')) {
            window.history.replaceState({}, document.title, window.location.pathname)
            this.finish()
        }

        // パターン2: 既存タブがあった場合（postMessage）
        navigator.serviceWorker.addEventListener('message', (event) => {
            if (event.data?.type === 'SHOW_MODAL') {
                this.finish()
            }
        })
    }

    setTime(event) {
  const minutes = event.params.minutes
  this.selectedSeconds = minutes * 60
  this.remainingTime = this.selectedSeconds

  if (this.hasDurationInputTarget) {
    this.durationInputTarget.value = minutes
  } else {
    console.error("durationInputTarget not found!")
  }

  // 選択状態の切り替え
  document.querySelectorAll('.duration-button').forEach(btn => {
    btn.classList.remove('bg-primary', 'text-white', 'shadow-md')
    btn.classList.add('text-text-secondary')
  })
  event.currentTarget.classList.add('bg-primary', 'text-white', 'shadow-md')
  event.currentTarget.classList.remove('text-text-secondary')

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

        //スタートボタンを消して休憩ボタンを表示
        this.startButtonTarget.classList.add("hidden")
        this.breakButtonTarget.classList.remove("hidden")

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

        //休憩ボタンを消してスタートボタンを表示
        this.breakButtonTarget.classList.add("hidden")
        this.startButtonTarget.classList.remove("hidden")

        const response = await fetch("/sitting_sessions/finish_current", {
            method: "PATCH",
            headers: {
                "Accept": "text/vnd.turbo-stream.html",
                "Content-Type": "application/json",
                "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
            }
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