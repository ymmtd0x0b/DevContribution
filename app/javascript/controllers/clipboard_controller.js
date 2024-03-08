import { Controller } from "@hotwired/stimulus"
import { NodeHtmlMarkdown } from "node-html-markdown"
import toast from '../toast'

// Connects to data-controller="copy-to-clipboard"
export default class extends Controller {
  static targets = [ 'allIssuesTable' ]

  connect() {
  }

  copy() {
    if (!navigator.clipboard) {
      Swal.fire({
        title: 'エラー',
        text: 'クリップボードへのコピー機能を利用できません',
        icon: 'error'
      })
      return;
    }

    const markdonwText = NodeHtmlMarkdown.translate(this.allIssuesTableTarget.outerHTML, { bulletMarker: '-' })
    navigator.clipboard.writeText(markdonwText).then(
      () => { toast('コピーしました', 'success') },
      () => { toast('コピーに失敗しました', 'error') }
    )
  }
}
