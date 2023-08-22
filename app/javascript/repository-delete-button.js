document.addEventListener('turbo:load', () => {
  const repositoryDeleteButton = document.querySelector('#repository_delete_button')
  repositoryDeleteButton.addEventListener('click', () => {
    const selectedRepository = document.querySelector('option:checked')
    fetch(`/repositories/${selectedRepository.getAttribute('value')}`, {
      method: 'DELETE',
      headers: headers(),
      credentials: 'same-origin',
      redirect: 'follow'
    }).then(res => {
      location.href = res.url
    })
  })
})


const getToken = () => {
  const meta = document.querySelector('meta[name="csrf-token"]')
  return meta ? meta.getAttribute('content') : ''
}

const headers = () => {
  return {
    'Content-Type': 'application/json; charset=utf-8',
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-Token': getToken()
  }
}
