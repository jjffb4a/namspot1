# docs/notes.md loverk 20.05.2025

## 🛠 Development Notes

- No filtering is applied — all names remain visible at all times.
- Highlighting is dynamic and applies on every keystroke.
- The search query is tracked using @tracked.
- Uses a Glimmer component with a computed getter for `filteredNames`.
- No Tailwind or CSS frameworks used — only minimal custom CSS.
- Keyboard interaction logic is simplified (no Enter key required).

## 🔍 Observations

- Great for demonstrating Ember reactivity basics.
- Easily extendable to support filtering later.
- All tests are located in `tests/integration/components/ui-box-test.js`.

## ✅ To Do

- Consider adding debounce for smoother UX.
- Improve a11y by using proper aria attributes.
- Add support for highlighting multiple matches.
