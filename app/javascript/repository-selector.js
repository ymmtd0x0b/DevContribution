document.addEventListener('turbo:load', () => {
  const repositorySelectors = document.getElementById('repository_id')

  if(!repositorySelectors) {
    return
  }

  repositorySelectors.addEventListener('change', (e) => {
    const current_tab = location.pathname.replace(/^.+\//, '')
    const search = location.search
    location.href = `/repositories/${e.target.value}/${current_tab + search}`
  })
})
