import { Tabs } from "tailwindcss-stimulus-components"

export default class OptimizedTabs extends Tabs {
  static targets = ['tab']
  static values = {
    index: 0
  }

  initialize() {
    const anchor = this.anchor
    if (anchor) this.indexValue = this.tabTargets.findIndex((tab) => tab.getAttribute('href') === anchor )
  }

  get anchor() {
    return window.location.pathname + window.location.search
  }

  showTab() {
    this.tabTargets.forEach((tab, index) => {
      if (index === this.indexValue) {
        tab.ariaSelected = 'true'
        tab.dataset.active =  true
        if (this.hasInactiveTabClass) tab?.classList?.remove(...this.inactiveTabClasses)
        if (this.hasActiveTabClass) tab?.classList?.add(...this.activeTabClasses)
      } else {
        tab.ariaSelected = null
        delete tab.dataset.active
        if (this.hasActiveTabClass) tab?.classList?.remove(...this.activeTabClasses)
        if (this.hasInactiveTabClass) tab?.classList?.add(...this.inactiveTabClasses)
      }
    })
  }
}
