import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="history"
export default class extends Controller {
  static targets = ["heatmapContainer", "dailyPane", "weeklyPane", "monthlyPane", "tab"]
  static values = {
    daily: Array,
    weekly: Array,
    monthly: Array,
    heatmap: Array
  }
  connect() {

    if (this.hasHeatmapValue) {
      this.renderHeatmap()
    }
  }

  renderHeatmap() {

    this.heatmapContainerTarget.innerHTML = ""

    this.heatmapValue.forEach(report => {

      const dot = document.createElement("div")
      const count = report.exercise_count || 0
      const date = report.date_label
      // tailwindのクラス付与
      dot.classList.add("w-4", "h-4", "rounded-sm", "border", "border-primary/30", "transition-all", "hover:border-primary", "hover:z-10")

      // 運動回数に応じた色
      let colorClass = ""
      switch (true) {
        case count >= 7: colorClass = "bg-primary", "border-primary/50"; break;
        case count >= 4: colorClass = "bg-primary/60", "border-primary/40"; break;
        case count >= 1: colorClass = "bg-primary/30", "border-primary/30"; break;
        default: colorClass = "bg-slate-200/50", "border-primary";
      }

      dot.classList.add(colorClass)
      dot.setAttribute("title", `${date}の運動: ${count}回`) //ホバー表示
      this.heatmapContainerTarget.appendChild(dot)

    })
  }

  switch(event) {
    const tab = event.currentTarget.dataset.tab
    this.showPane(tab)
  }

  showPane(tab) {
    const panes = ["daily", "weekly", "monthly"]
    panes.forEach(p => {
      const isTarget = p === tab
      this[`${p}PaneTargets`].forEach(el => el.classList.toggle("hidden", !isTarget))
    })

    this.tabTargets.forEach(t => {
      const isActive = t.dataset.tab === tab
      t.classList.toggle("bg-white", isActive)
      t.classList.toggle("shadow-sm", isActive)
      t.classList.toggle("text-text-secondary", !isActive)
    })
  }
}
