import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { boardId: Number, commentId: Number }

  edit() {
    const url = `/boards/${this.boardIdValue}/comments/${this.commentIdValue}/edit`
    const frame = document.getElementById(`comment_${this.commentIdValue}`)
    if (frame) {
      frame.innerHTML = `<turbo-frame src="${url}"></turbo-frame>`
    }
  }
}
