import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  static values = {
    message: String,
    messageType: String
  }

  connect() {
    Swal.fire({
      title: this.messageValue,
      icon: this.messageTypeValue,
      toast: true,
      position: 'top',
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true
    })
  }
}
