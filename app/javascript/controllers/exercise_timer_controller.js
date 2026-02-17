import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="exercise-timer"
export default class extends Controller {
  static targets = ["bar", "text"]
  // 5分(300秒)を定義
  static values = { duration: { type: Number, default: 300 } }

  connect() {
    this.timeLeft = this.durationValue
    this.startTimer()
  }

  startTimer() {
    this.interval = setInterval(() => {
      this.timeLeft--
      this.updateDisplay()

      if (this.timeLeft <= 0) {
        clearInterval(this.interval)
        this.complete()
      }
    }, 1000)
  }

  updateDisplay() {
    const progress = (this.timeLeft / this.durationValue) * 100
    this.barTarget.style.width = `${progress}%`

    if (this.hasTextTarget) {
      const mins = Math.floor(this.timeLeft / 60)
      const secs = this.timeLeft % 60
      this.textTarget.textContent = `${mins}:${secs.toString().padStart(2, '0')}`
    }
  }

  complete() {
    this.barTarget.classList.replace("bg-primary", "bg-green-400")
  }

  disconnect() {
    clearInterval(this.interval)
  }
}
