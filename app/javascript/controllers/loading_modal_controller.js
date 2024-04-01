import { Controller } from "@hotwired/stimulus"
import Swal from 'sweetalert2'

// Connects to data-controller="loading-modal"
export default class extends Controller {
  connect() {
    Swal.fire({
      title: '処理を実行中です<br>しばらくお待ちください...',
      allowEscapeKey: false,
      allowOutsideClick: false,
      showConfirmButton: false,
      customClass: {
        title: 'text-2xl text-gray-600 font-medium'
      },
      willOpen: () => {
        Swal.showLoading()
      }
    })
  }
}
