import { Controller } from '@hotwired/stimulus'
import loadingModal from '../loading_modal.js'
import Swal from 'sweetalert2'

// Connects to data-controller="loading-modal"
export default class extends Controller {
  connect() {
    loadingModal()
  }

  disconnect() {
    Swal.close()
  }
}
