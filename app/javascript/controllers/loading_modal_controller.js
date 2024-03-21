import { Controller } from "@hotwired/stimulus"
import Swal from 'sweetalert2'

// Connects to data-controller="loading-modal"
export default class extends Controller {
  static values = {
    status: String
  }

  connect() {
    if(this.statusValue == 'loading') {
      Swal.fire({
        title: 'リポジトリを探しています<br>しばらくお待ちください...',
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
    } else if(this.statusValue == 'close') {
      Swal.close()
    }
  }
}
