import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  static targets = ['toast']

  connect() {
    setTimeout(() => {
      this.toastTarget.classList.add('animate-fade-out')
    }, 3000)
  }
}
