import { NodeHtmlMarkdown } from "node-html-markdown";

document.addEventListener('turbo:load', () => {
  const clipboardWriteButton = document.querySelector('#clipboard_write_button')

  if(!clipboardWriteButton) {
    return null;
  }

  clipboardWriteButton.addEventListener('click', () => {
    if (!navigator.clipboard) {
      alert('このブラウザではこの機能を利用できません')
      return;
    }

    const allItemsTable = document.querySelector('#all-items-table')
    const result = NodeHtmlMarkdown.translate(allItemsTable.outerHTML, { bulletMarker: '-' })
    navigator.clipboard.writeText(result)
    alert('クリップボードにコピーしました')
    return;
  })
})
