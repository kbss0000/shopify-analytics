import { Controller } from "@hotwired/stimulus"
import tippy from "tippy.js"

export default class extends Controller {
  connect() {
    this.element.querySelectorAll('[data-tippy-content]').forEach(el => {
      tippy(el, {
        theme: 'light',
        animation: 'scale',
      })
    })
  }
}
