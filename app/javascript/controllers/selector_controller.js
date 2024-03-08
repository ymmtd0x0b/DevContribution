import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="selector"
export default class extends Controller {
  connect() {
  }

  change(element) {
    Turbo.visit(location.pathname.replace(/repositories\/\d+/, `repositories/${element.target.value}`))
  }
}
