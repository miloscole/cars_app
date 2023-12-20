import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:submit-end", (event) => {
      if (event.detail.success) {
        this.closeModal()
      }
    })
  }

  closeModal() {
    this.element.parentElement.removeAttribute("src")
    this.element.remove()
  }
}
