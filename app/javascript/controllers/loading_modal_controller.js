import { Controller } from "@hotwired/stimulus"
import loadingModal from '../loading_modal.js'

// Connects to data-controller="loading-modal"
export default class extends Controller {
  static values = {
    hidden: Boolean
  }

  connect() {
    loadingModal()
  }
}
