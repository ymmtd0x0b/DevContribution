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

    const deliverableContainer = document.querySelector('.deliverable-container')
    const result = NodeHtmlMarkdown.translate(deliverableContainer.outerHTML)
    navigator.clipboard.writeText(result)
    alert('クリップボードにコピーしました')
    return;
  })
})
