import Swal from 'sweetalert2'

export default function (title, type) {
  Swal.fire({
    title: title,
    icon: type,
    toast: true,
    position: 'top',
    showConfirmButton: false,
    timer: 3000,
    timerProgressBar: true
  })
}
