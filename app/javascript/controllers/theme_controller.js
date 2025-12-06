import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "icon" ]

  connect() {
    this.loadTheme()
  }

  toggle() {
    if (document.documentElement.classList.contains('dark')) {
      this.setLightMode()
    } else {
      this.setDarkMode()
    }
  }

  setDarkMode() {
    document.documentElement.classList.add('dark')
    localStorage.theme = 'dark'
    // Update icon if needed (optional)
  }

  setLightMode() {
    document.documentElement.classList.remove('dark')
    localStorage.theme = 'light'
  }

  loadTheme() {
    // On page load or when changing themes, best to add inline in the head to avoid FOUC
    if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }
}
