import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      console.log('rrrrrrrr');
      this.element.remove()
    }, 2000);
  }
}
