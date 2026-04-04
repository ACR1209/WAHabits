import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "form", "list"]

  openDialog(event) {
    event.preventDefault()
    this.dialogTarget.showModal()

    // Reset form fields
    this.formTarget.reset()
  }

  closeDialog() {
    this.dialogTarget.close()
  }

  async submitForm(event) {
    event.preventDefault()
    const form = this.formTarget
    const response = await fetch(form.action, {
      method: form.method,
      headers: { "Accept": "text/vnd.turbo-stream.html" },
      body: new FormData(form)
    })
    if (response.ok) {
      this.closeDialog()
      Turbo.visit(window.location.href, { action: "replace" })
    } else {
      const html = await response.text()
      this.dialogTarget.innerHTML = html
    }
  }
}
