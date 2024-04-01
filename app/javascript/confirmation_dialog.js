import Swal from 'sweetalert2'

Turbo.setConfirmMethod((message, element) => {
  return new Promise((resolve, reject) => {
    Swal.fire({
      text: message || '本当に実行しますか？',
      icon: 'warning',
      showCancelButton: true
    }).then((result) => {
      resolve(result.isConfirmed)
    }).catch(error => { reject(error) })
  })
})
