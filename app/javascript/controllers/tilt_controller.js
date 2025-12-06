import { Controller } from "@hotwired/stimulus"
import VanillaTilt from "vanilla-tilt"

export default class extends Controller {
  connect() {
    VanillaTilt.init(this.element, {
      max: 15,
      speed: 400,
      glare: true,
      "max-glare": 0.2,
      scale: 1.02
    })
  }
  
  disconnect() {
    if (this.element.vanillaTilt) {
      this.element.vanillaTilt.destroy()
    }
  }
}
