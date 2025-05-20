# increment-v2-debug-toggle.sh — loverk 20.05.2025

mkdir -p app/components && cat > app/components/debug-toggle.js <<'EOF'
// app/components/debug-toggle.js loverk 20.05.2025
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

export default class DebugToggleComponent extends Component {
  @tracked enabled = false;

  get statusText() {
    return this.enabled ? 'Debug mode ON' : 'Debug mode OFF';
  }

  @action toggle(e) {
    this.enabled = e.target.value === 'true';
    console.log(`[debug-toggle] Toggled: ${this.enabled}`);
  }
}
EOF

mkdir -p app/templates/components && cat > app/templates/components/debug-toggle.hbs <<'EOF'
{{! app/templates/components/debug-toggle.hbs loverk 20.05.2025 }}
<div style="margin-bottom: 1rem;">
  <label for="debug">🪵 Debug Mode:</label>
  <select id="debug" {{on "change" this.toggle}}>
    <option value="false">OFF</option>
    <option value="true">ON</option>
  </select>
  <p><strong>{{this.statusText}}</strong></p>
</div>
EOF

# Patch app/templates/application.hbs to include the component
sed -i '' '/<UiBox/ i\
  <DebugToggle />
' app/templates/application.hbs

mkdir -p docs && cat > docs/notes_v2.md <<'EOF'
# docs/notes_v2.md — loverk 20.05.2025

## v2: Debug Toggle Dropdown

- Introduced `<DebugToggle />` component.
- Select between "ON" and "OFF" to control debugging output.
- Logs appear in browser console when toggled ON.

This sets up an extensible debug mode interface.
EOF

git add .
git commit -m "v2: 🪵 Debug dropdown toggle component added"
git push
