import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="history"
export default class extends Controller {
  static targets = ["heatmapContainer", "dailyPane", "weeklyPane", "monthlyPane"]
  static values = {
    Daily: Array,
    Weekly: Array,
    Monthly: Array,
    Heatmap: Array
  }
  connect() {

  }
}
