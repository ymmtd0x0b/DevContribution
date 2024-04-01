import Swal from 'sweetalert2'

Turbo.setConfirmMethod((message, element) => {
  return new Promise((resolve, reject) => {
    Swal.fire({
      text: message || '本当に実行しますか？',
      icon: 'warning',
      showCancelButton: true
    }).then((result) => {
      if (result.isConfirmed) {
        resolve(result.isConfirmed)
        if (element.attributes.getNamedItem('method').value == 'patch') {
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
    }).catch(error => { reject(error) })
  })
})
