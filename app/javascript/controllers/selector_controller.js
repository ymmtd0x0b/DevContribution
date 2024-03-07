import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="selector"
export default class extends Controller {
  connect() {
  }

  change(e) {
    location.href = location.pathname.replace(/repositories\/\d+/, `repositories/${e.target.value}`)
  }
}
