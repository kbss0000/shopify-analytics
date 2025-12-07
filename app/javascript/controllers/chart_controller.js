import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chart"
export default class extends Controller {
  connect() {
    // Ensure charts render after Turbo navigation
    this.renderCharts()
  }

  renderCharts() {
    // Wait for Chartkick to be available
    if (typeof Chartkick !== 'undefined') {
      // Charts should auto-render, but we can force a refresh if needed
      setTimeout(() => {
        if (typeof Chartkick !== 'undefined' && Chartkick.charts) {
          // Trigger re-render of all charts
          document.querySelectorAll('[data-chart]').forEach((element) => {
            if (element.chartkickChart) {
              element.chartkickChart.update()
            }
          })
        }
      }, 100)
    }
  }
}

