import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fields", "data"];
  static values = { existingFields: Object };

  // connect() runs once when the controller element enters the DOM.
  // This is where we pre-populate rows for the edit action.
  connect() {
    Object.entries(this.existingFieldsValue).forEach(([name, field]) => {
      this.fieldsTarget.insertAdjacentHTML(
        "beforeend",
        this.#buildRow(name, field.type, field.value),
      );
    });
  }

  // Wired to the form via data-action="submit->character-sheet-#serialize"
  // Runs before the form submits, populating the hidden :data field with JSON.
  serialize() {
    const data = {};
    this.fieldsTarget.querySelectorAll(".field-row").forEach((row) => {
      // Name is stored in a data attribute on the row since <label> has no .value
      const name = row.dataset.fieldName;
      const type = row.querySelector(".field-type").value;
      const valueEl = row.querySelector(".field-value");
      // Checkboxes expose their state via .checked, not .value
      const value = type === "boolean" ? valueEl.checked : valueEl.value;
      if (name) data[name] = { type, value };
    });
    this.dataTarget.value = JSON.stringify(data);
  }

  // Private methods (# prefix) — implementation details not meant to be called externally.

  #buildRow(name, type, value) {
    let formField;
    switch (type) {
      case "string":
        formField = `<input class="form-control field-value" value="${this.#escapeHtml(value)}">`;
        break;
      case "number":
        formField = `<input class="form-control field-value" type="number" value="${this.#escapeHtml(value)}">`;
        break;
      case "boolean":
        // <checkbox> isn't a real element; checked state is an attribute, not value=
        formField = `<input type="checkbox" class="form-check-input field-value" ${value === true || value === "true" ? "checked" : ""}>`;
        break;
      case "text":
        // <textarea> content goes between tags, not in value=; needs a closing tag
        formField = `<textarea class="form-control field-value" rows="4">${this.#escapeHtml(value)}</textarea>`;
        break;
      default:
        formField = `<input class="form-control field-value" value="${this.#escapeHtml(value)}">`;
    }

    return `
      <div class="row mb-md-4 field-row" data-field-name="${this.#escapeHtml(name)}">
        <div class="col">
          <label class="form-label">${this.#escapeHtml(name)}</label>
          ${formField}
          <input type="hidden" class="field-type" value="${this.#escapeHtml(type)}">
        </div>
      </div>`;
  }

  #escapeHtml(str) {
    // Convert to string first — value from JSONB can be a boolean or number
    return String(str ?? "")
      .replace(/&/g, "&amp;")
      .replace(/"/g, "&quot;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  }
}
