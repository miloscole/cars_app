import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="height"
export default class extends Controller {
  connect() {
    this.adjustHeight()
  }

  adjustHeight() {
    const initial_height = this.element.offsetHeight
    const full_screen_height = window.innerHeight

    const height_diff = initial_height - full_screen_height

    this.element.style.height = (height_diff < 0) ? `${full_screen_height}px` : `${initial_height}px`
  }
}
