import Swal from 'sweetalert2'
import loadingModal from './loading_modal.js'

Turbo.setConfirmMethod((message, element) => {
  return new Promise((resolve, reject) => {
    Swal.fire({
      text: message || '本当に実行しますか？',
      icon: 'warning',
      showCancelButton: true
    }).then((result) => {
      const id = element.getAttribute('id')
      if(result.isConfirmed && id == 'repository_update_button') {
        loadingModal()
      }
      resolve(result.isConfirmed)
    }).catch(error => { reject(error) })
  })
})
