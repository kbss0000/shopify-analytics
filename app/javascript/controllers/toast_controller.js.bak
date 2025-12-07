import { Controller } from "@hotwired/stimulus"
import { animate } from "motion"

export default class extends Controller {
  connect() {
    // Slide in from bottom-right
    animate(
      this.element,
      { opacity: [0, 1], x: [50, 0], scale: [0.9, 1] },
      { duration: 0.4 }
    )

    // Auto-dismiss after 5 seconds
    setTimeout(() => {
      this.close()
    }, 5000)
  }

  close() {
    animate(
      this.element,
      { opacity: 0, x: 50, scale: 0.9 },
      { duration: 0.3 }
    ).finished.then(() => {
      this.element.remove()
    })
  }
}
