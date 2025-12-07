import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["active", "inactive"]

  connect() {
    this.activeClass = ["bg-primary/20", "text-primary"]
    this.inactiveClass = ["text-muted-foreground", "hover:text-foreground"]

    // Set initial active state based on URL params
    const urlParams = new URLSearchParams(window.location.search)
    const startDate = urlParams.get('start_date')

    if (!startDate) {
      // Default to 1M if no param (matches controller default)
      this.setActiveButton('1M')
    } else {
      const days = Math.round((new Date() - new Date(startDate)) / (1000 * 60 * 60 * 24))
      if (days <= 8) this.setActiveButton('1W')
      else if (days <= 31) this.setActiveButton('1M')
      else if (days <= 183) this.setActiveButton('6M')
      else this.setActiveButton('1Y')
    }
  }

  activate(event) {
    const range = event.currentTarget.dataset.range
    const today = new Date()
    let startDate = new Date()

    switch (range) {
      case '1W':
        startDate.setDate(today.getDate() - 7)
        break
      case '1M':
        startDate.setDate(today.getDate() - 30)
        break
      case '6M':
        startDate.setDate(today.getDate() - 180)
        break
      case '1Y':
        startDate.setDate(today.getDate() - 365)
        break
    }

    const params = new URLSearchParams(window.location.search)
    params.set('start_date', startDate.toISOString().split('T')[0])
    params.set('end_date', today.toISOString().split('T')[0])

    // Turbo visit if available for smoother experience, else full reload
    if (window.Turbo) {
      window.Turbo.visit(`${window.location.pathname}?${params.toString()}`)
    } else {
      window.location.href = `${window.location.pathname}?${params.toString()}`
    }
  }

  setActiveButton(rangeLabel) {
    this.element.querySelectorAll("button").forEach(button => {
      if (button.textContent.trim() === rangeLabel) {
        button.classList.remove(...this.inactiveClass)
        button.classList.add(...this.activeClass)
      } else {
        button.classList.remove(...this.activeClass)
        button.classList.add(...this.inactiveClass)
      }
    })
  }
}
