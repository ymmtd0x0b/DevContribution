import { Controller } from '@hotwired/stimulus'
import { NodeHtmlMarkdown } from 'node-html-markdown'
import Swal from 'sweetalert2'

// Connects to data-controller="copy-to-clipboard"
export default class extends Controller {
  static targets = ['allIssuesTable', 'defaultMessage', 'successMessage']

  connect () {
  }

  copy () {
    if (!navigator.clipboard) {
      Swal.fire({
        title: 'エラー',
        text: 'クリップボードへのコピー機能を利用できません',
        icon: 'error'
      })
      return
    }

    const markdonwText = NodeHtmlMarkdown.translate(this.allIssuesTableTarget.outerHTML, { bulletMarker: '-' })
    navigator.clipboard.writeText(markdonwText).then(() => {
      this.defaultMessageTarget.classList.add('hidden')
      this.successMessageTarget.classList.remove('hidden')

      // reset to default state
      setTimeout(() => {
        this.defaultMessageTarget.classList.remove('hidden')
        this.successMessageTarget.classList.add('hidden')
      }, 2000)
    })
  }
}
