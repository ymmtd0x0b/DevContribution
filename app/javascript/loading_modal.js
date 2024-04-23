import Swal from 'sweetalert2'

export default function loadingModal () {
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
