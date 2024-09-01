import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="popup"
export default class extends Controller {
  static targets = ['modal', 'dialog', 'loading']

  hello() {
    this.dialogTarget.classList.add('hidden')
    this.loadingTarget.classList.remove('hidden')
    this.modalTarget.classList.add('pointer-events-none')
  }
}
