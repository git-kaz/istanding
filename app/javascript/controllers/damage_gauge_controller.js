import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="damage-gauge"
export default class extends Controller {

  static targets = ["gauge", "hpText"]

  static values = { hp: { type: Number, default: 0 } }

  connect() {
    setTimeout(() => {
      this.gaugeTarget.style.width = `${this.hpValue}%`
      this.hpTextTarget.textContent = `${this.hpValue} / 100`
    }, 100) //ゲージ更新アニメーションのためdelay
  }
}
