# docs/notes_v4.md — loverk 20.05.2025

## v4: Add Mirage + Test Scenarios

### ✅ Features Added
- Integrated `ember-cli-mirage` with custom endpoint `/api/names`.
- Service `name-loader` fetches and tracks names.
- `<UiBox />` uses service on startup.
- Test loads `UiBox` and validates rendering Mirage data.

🧪 Prepares base for testing dynamic/mock-driven UI with data fallback.

Next: convert to TypeScript (v5)
