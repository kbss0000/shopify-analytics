import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["message"]

    connect() {
        // Auto-dismiss after 4 seconds
        this.messageTargets.forEach((message) => {
            setTimeout(() => {
                this.dismissMessage(message)
            }, 4000)
        })
    }

    dismiss(event) {
        const message = event.target.closest("[data-flash-target='message']")
        if (message) {
            this.dismissMessage(message)
        }
    }

    dismissMessage(message) {
        message.style.opacity = '0'
        message.style.transform = 'translateX(100%)'
        message.style.transition = 'opacity 0.3s ease-out, transform 0.3s ease-out'

        setTimeout(() => {
            message.remove()
            // Remove container if no messages left
            if (this.messageTargets.length === 0) {
                this.element.remove()
            }
        }, 300)
    }
}
