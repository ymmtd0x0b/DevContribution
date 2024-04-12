import Swal from 'sweetalert2'

Turbo.setConfirmMethod((message, element) => {
  return new Promise((resolve, reject) => {
    Swal.fire({
      text: message || '本当に実行しますか？',
      icon: 'warning',
      showCancelButton: true
    }).then((result) => {
      const id = element.getAttribute('id')
      if(result.isConfirmed && id == 'repository_update_button') {
        Swal.fire({
          title: '処理を実行中です<br>しばらくお待ちください...',
          allowEscapeKey: false,
          allowOutsideClick: false,
          showConfirmButton: false,
          customClass: {
            title: 'text-2xl text-gray-600 font-medium'
          },
          didOpen: () => {
            Swal.showLoading()
          }
        })
      }
      resolve(result.isConfirmed)
    }).catch(error => { reject(error) })
  })
})
