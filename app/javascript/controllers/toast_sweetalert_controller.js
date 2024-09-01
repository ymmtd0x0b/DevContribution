import { Controller } from '@hotwired/stimulus'
import Swal from 'sweetalert2'

function toast(title, type) {
  Swal.fire({
    title,
    icon: type,
    toast: true,
    position: 'top-end',
    showConfirmButton: false,
    timer: 3000,
    timerProgressBar: true
  })
}

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
