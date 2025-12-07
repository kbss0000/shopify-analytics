import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  connect() {
    this.checkScreenSize()
    window.addEventListener('resize', this.checkScreenSize.bind(this))
  }

  disconnect() {
    window.removeEventListener('resize', this.checkScreenSize.bind(this))
  }

  checkScreenSize() {
    if (window.innerWidth >= 1024) {
      this.sidebarTarget.classList.remove("-translate-x-full")
      this.overlayTarget.classList.add("hidden")
    } else {
      this.sidebarTarget.classList.add("-translate-x-full")
      this.overlayTarget.classList.add("hidden")
    }
  }

  open() {
    this.sidebarTarget.classList.remove("-translate-x-full")
    this.overlayTarget.classList.remove("hidden")
  }

  close() {
    this.sidebarTarget.classList.add("-translate-x-full")
    this.overlayTarget.classList.add("hidden")
  }
}
