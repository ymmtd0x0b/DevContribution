document.addEventListener('turbo:load', () => {
  const clipboardWriteButton = document.querySelector('#clipboard_write_button')

  if(!clipboardWriteButton) {
    return null;
  }

  clipboardWriteButton.addEventListener('click', () => {
    if (!navigator.clipboard) {
      alert("このブラウザではこの機能を利用できません")
      return;
    }

    // ここに HTML を Markdown へ変換する処理を実装する

    // navigator.clipboard.writeText('copied!!!')
  })
})
