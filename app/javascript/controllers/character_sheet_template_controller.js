import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fields", "data"];
  static values = { existingFields: Object };

  // connect() runs once when the controller element enters the DOM.
  // This is where we pre-populate rows for the edit action.
  connect() {
    Object.entries(this.existingFieldsValue).forEach(([name, type]) => {
      this.fieldsTarget.insertAdjacentHTML(
        "beforeend",
        this.#buildRow(name, type),
      );
    });
  }

  // Wired to the "Add Field" button via data-action="click->character-sheet-template#addField"
  addField() {
    this.fieldsTarget.insertAdjacentHTML(
      "beforeend",
      this.#buildRow("", "string"),
    );
  }

  // Wired to each remove button via data-action="click->character-sheet-template#removeField"
  // event.target is the button that was clicked; .closest() walks up to the row.
  removeField(event) {
    event.target.closest(".field-row").remove();
  }

  // Wired to the form via data-action="submit->character-sheet-template#serialize"
  // Runs before the form submits, populating the hidden :data field with JSON.
  serialize() {
    const data = {};
    this.fieldsTarget.querySelectorAll(".field-row").forEach((row) => {
      const name = row.querySelector(".field-name").value.trim();
      const type = row.querySelector(".field-type").value;
      if (name) data[name] = type;
    });
    this.dataTarget.value = JSON.stringify(data);
  }

  // Private methods (# prefix) — implementation details not meant to be called externally.

  #buildRow(name, type) {
    const options = [
      ["string", "Text"],
      ["number", "Number"],
      ["boolean", "Checkbox"],
      ["text", "Text Area"],
    ]
      .map(
        ([value, label]) =>
          `<option value="${value}"${value === type ? " selected" : ""}>${label}</option>`,
      )
      .join("");

    return `
      <div class="row mb-md-4 field-row">
        <div class="col">
          <label class="form-label">Field Name</label>
          <input class="form-control field-name" placeholder="e.g. Strength" value="${this.#escapeHtml(name)}">
        </div>
        <div class="col">
          <label class="form-label">Field Type</label>
          <select class="form-control field-type">${options}</select>
        </div>
        <div class="col-auto d-flex align-items-end">
          <button type="button" class="btn btn-sm btn-danger"
                  data-action="click->character-sheet-template#removeField">Remove</button>
        </div>
      </div>`;
  }

  #escapeHtml(str) {
    return str
      .replace(/&/g, "&amp;")
      .replace(/"/g, "&quot;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  }
}
