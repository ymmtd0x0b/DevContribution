import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="button"
export default class extends Controller {
  static targets = ['form', 'submitButton']

  click() {
    document.body.classList.add('cursor-wait')

    const ankers = document.querySelectorAll('a')
    ankers.forEach((anker) => {
      anker.addEventListener('click', (event) => { event.preventDefault() })
      anker.classList.add('cursor-wait')
    })

    const buttons = document.querySelectorAll('button')
    if(buttons.length > 0) {
      buttons.forEach((button) => {
        button.disabled = true
        button.classList.add('cursor-wait')
        const cssClassList = button.className.match(/hover:[^ ]+/g)
        if(cssClassList !== null) {
          cssClassList.forEach((cssClass) => { button.classList.remove(cssClass) })
        }
      })
    }

    this.formTarget.requestSubmit(this.submitButtonTarget)
  }
}
