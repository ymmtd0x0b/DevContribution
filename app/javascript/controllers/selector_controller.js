import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="selector"
export default class extends Controller {
  connect() {
  }

  change(element) {
    const frameTarget = document.querySelector('turbo-frame#main')
    frameTarget.src = location.pathname.replace(/repositories\/\d+/, `repositories/${element.target.value}`)
  }
}
