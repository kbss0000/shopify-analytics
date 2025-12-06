import { Controller } from "@hotwired/stimulus"
import { animate, spring } from "motion"

export default class extends Controller {
  static targets = [ "sidebar", "overlay" ]

  connect() {
    // Check screen size on connect
    this.checkScreenSize()
    window.addEventListener('resize', this.checkScreenSize.bind(this))
  }

  disconnect() {
    window.removeEventListener('resize', this.checkScreenSize.bind(this))
  }

  checkScreenSize() {
    if (window.innerWidth >= 1024) {
      // Desktop: always show
      this.sidebarTarget.classList.remove("-translate-x-full")
      this.overlayTarget.classList.add("hidden")
    } else {
      // Mobile: hide by default
      this.sidebarTarget.classList.add("-translate-x-full")
      this.overlayTarget.classList.add("hidden")
    }
  }

  open() {
    this.sidebarTarget.classList.remove("-translate-x-full")
    this.overlayTarget.classList.remove("hidden")
    
    // Animate overlay
    animate(
      this.overlayTarget,
      { opacity: [0, 1] },
      { duration: 0.2 }
    )
    
    // Animate sidebar slide in
    animate(
      this.sidebarTarget,
      { x: [-300, 0] },
      { duration: 0.4, easing: spring() }
    )
  }

  close() {
    const sidebar = this.sidebarTarget
    const overlay = this.overlayTarget

    animate(
      sidebar,
      { x: [0, -300] },
      { duration: 0.3 }
    ).finished.then(() => {
      sidebar.classList.add("-translate-x-full")
    })

    animate(
      overlay,
      { opacity: [1, 0] },
      { duration: 0.2 }
    ).finished.then(() => {
      overlay.classList.add("hidden")
    })
  }
}
