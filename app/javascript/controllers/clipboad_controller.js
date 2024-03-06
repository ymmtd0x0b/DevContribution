import { Controller } from "@hotwired/stimulus"
import { NodeHtmlMarkdown } from "node-html-markdown";

// Connects to data-controller="copy-to-clipboad"
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

    const Toast = Swal.mixin({
      toast: true,
      position: 'top',
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true
    })

    const markdonwText = NodeHtmlMarkdown.translate(this.allIssuesTableTarget.outerHTML, { bulletMarker: '-' })
    navigator.clipboard.writeText(markdonwText).then(
      () => {
        Toast.fire({
          title: 'コピーに成功しました',
          icon: 'success'
        })
      },
      () => {
        Toast.fire({
          title: 'コピーに失敗しました',
          icon: 'error',
          text: 'ページをリロードすると改善するかも知れません'
        })
      }
    )
  }
}
