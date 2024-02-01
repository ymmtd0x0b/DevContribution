document.addEventListener('turbo:load', () => {
  const repositorySelectors = document.getElementById('repository_id')

  if(!repositorySelectors) {
    return
  }

  repositorySelectors.addEventListener('change', (e) => {
    location.href = location.pathname.replace(/repositories\/\d+/, `repositories/${e.target.value}`)
  })
})
