import { Controller } from "@hotwired/stimulus"
import toast from '../toast'

// Connects to data-controller="toast"
export default class extends Controller {
  static values = {
    message: String,
    messageType: String
  }

  connect() {
    toast(this.messageValue, this.messageTypeValue)
  }
}
