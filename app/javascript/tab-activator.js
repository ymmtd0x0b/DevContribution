document.addEventListener('turbo:load', () => {
  const currentPath = location.pathname
  const currentTab = document.querySelector(`a[href='${currentPath}']`)
  currentTab.classList.add('tab-active')
})
