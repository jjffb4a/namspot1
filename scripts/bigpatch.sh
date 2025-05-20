#!/bin/bash

# dev/scripts/namspot1-dev-series.sh  — loverk 20.05.2025
# This script provides a step-by-step framework to evolve the Namspot1 Ember.js app.
# Each part appends or patches incrementally.

################################################################################
# 1️⃣ Enhance CSS layout (plain CSS upgrade)
################################################################################
mkdir -p app/styles && cat > app/styles/ui-box.css <<'EOF'
/* app/styles/ui-box.css — loverk 20.05.2025 */
.box {
  padding: 1rem;
  background: #fdfdfd;
  border: 1px solid #ccc;
  border-radius: 6px;
  box-shadow: 0 0 0.5rem rgba(0,0,0,0.1);
  max-width: 480px;
  margin: 2rem auto;
  font-family: sans-serif;
}
input {
  width: 100%;
  padding: 0.5rem;
  font-size: 1rem;
  margin-bottom: 1rem;
}
ul {
  list-style: none;
  padding-left: 0;
}
li {
  padding: 0.5rem;
  border-bottom: 1px solid #eee;
}
mark {
  background: #ffe100;
  font-weight: bold;
}
EOF

################################################################################
# 2️⃣ Add debug mode dropdown (alternative branch: debug-mode)
################################################################################
git checkout -b debug-mode
mkdir -p app/components && cat > app/components/debug-toggle.js <<'EOF'
// app/components/debug-toggle.js — loverk 20.05.2025
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

export default class DebugToggleComponent extends Component {
  @tracked level = 'none';

  get options() {
    return ['none', 'basic', 'verbose'];
  }

  @action
  updateLevel(e) {
    this.level = e.target.value;
    console.log('[debug-toggle] level set to', this.level);
  }
}
EOF

mkdir -p app/components && cat > app/components/debug-toggle.hbs <<'EOF'
<!-- app/components/debug-toggle.hbs -->
<label for="debug">Debug Mode:</label>
<select id="debug" {{on "change" this.updateLevel}}>
  {{#each this.options as |opt|}}
    <option value={{opt}} selected={{eq opt this.level}}>{{opt}}</option>
  {{/each}}
</select>
EOF

echo "🪛 Debug toggle component added. Commit and merge as needed."

################################################################################
# 3️⃣ Add Tailwind CSS v4 setup (Ember v6+ style)
################################################################################
git checkout main
pnpm add -D tailwindcss@next postcss@latest autoprefixer@latest
npx tailwindcss init -p

cat > tailwind.config.js <<'EOF'
// tailwind.config.js — Tailwind v4 ready
export default {
  content: [
    './app/**/*.{hbs,js,ts}',
    './tests/**/*.{hbs,js,ts}'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
EOF

cat > app/styles/app.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

echo "✅ Tailwind v4 config applied."

################################################################################
# 4️⃣ Add Mirage and test scenarios
################################################################################
pnpm add -D ember-cli-mirage
ember generate mirage-config
cat > mirage/config.js <<'EOF'
export default function() {
  this.namespace = '/api';
  this.get('/names', () => [
    { id: '1', text: 'Alice loves Ember' },
    { id: '2', text: 'Bob is cool' },
    { id: '3', text: 'Clara writes JS' }
  ]);
}
EOF

echo "🧪 Mirage and scenario mocks added."

################################################################################
# 5️⃣ Convert to TypeScript (patch, not rewrite)
################################################################################
mkdir -p types && cat > types/ui-box.d.ts <<'EOF'
// types/ui-box.d.ts — placeholder for types
export interface NameEntry {
  id: string;
  text: string;
}
EOF

# Example: mv .js to .ts and update class
mv app/components/ui-box.js app/components/ui-box.ts
sed -i '' '1s/.*/import Component from "@glimmer/component";/' app/components/ui-box.ts

echo "🔁 TypeScript conversion initiated. Adjust individual files progressively."

################################################################################
# 6️⃣ Prepare for Polarion-based structure
################################################################################
mkdir -p polarion && cat > polarion/README.md <<'EOF'
# Polarion Migration Notes — loverk 20.05.2025

- Structure to align with enterprise QA pipelines
- Integration plans with CI/CD runners
- Expect `pnpm`, `embroider`, and e2e scripts to be isolated here

_TODO: define folder mappings and environment constraints_
EOF

################################################################################
# Finalize notes file
################################################################################
mkdir -p docs && cat > docs/notes_v6.md <<'EOF'
# docs/notes_v6.md — Namspot1 Development Log

## ✅ v1–v6 Progress

- Layout CSS added
- Debug dropdown on branch `debug-mode`
- Tailwind CSS v4 setup done (via `tailwind.config.js`)
- Mirage config and mock API installed
- TypeScript migration started
- Polarion placeholder setup created

EOF

echo "🎉 All dev steps applied. Review changes, test locally, and commit when ready."

exit 0
