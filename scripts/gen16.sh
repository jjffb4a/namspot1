#!/bin/bash
# v16.sh loverk 2025-05-21
# ✅ Polarion-ready baseline patch script (TS, Tailwind, Mirage, Debug, CI, etc.)

set -e

echo "\n🔧 V16: Applying Polarion-ready baseline upgrades..."

### 1. Ensure correct packages
pnpm add -D tailwindcss postcss autoprefixer @tailwindcss/forms ember-cli-mirage ember-cli-deprecation-workflow ember-a11y-testing ember-template-lint ember-cli-github-pages typescript

### 2. TailwindCSS setup (skip if already exists)
if [ ! -f tailwind.config.js ]; then
  npx tailwindcss init
fi

mkdir -p app/styles && cat > app/styles/app.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

### 3. Update ember-cli-build.js to use Tailwind
if ! grep -q 'tailwind' ember-cli-build.js; then
  sed -i '' "/'use strict';/a\
  const tailwind = require('tailwindcss');\
" ember-cli-build.js
fi

### 4. Patch tsconfig for .gts/.ts
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "es2022",
    "module": "es2022",
    "strict": true,
    "moduleResolution": "node",
    "esModuleInterop": true,
    "baseUrl": ".",
    "paths": {
      "*": ["types/*"]
    }
  },
  "include": ["app/**/*", "tests/**/*"]
}
EOF

### 5. Mirage Setup
mkdir -p mirage && cat > mirage/config.js <<'EOF'
export default function () {
  this.namespace = '/api';
  this.get('/names', () => {
    return [
      { id: '1', text: 'Alice went to Berlin' },
      { id: '2', text: 'Clara likes Ember.js' },
      { id: '3', text: 'Bob and Eva at the park' }
    ];
  });
}
EOF

### 6. DebugToggle component
mkdir -p app/components/debug-toggle && cat > app/components/debug-toggle.gts <<'EOF'
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';

export default class DebugToggleComponent extends Component {
  @tracked enabled = false;

  toggle() {
    this.enabled = !this.enabled;
  }
}
EOF

cat > app/components/debug-toggle.hbs <<'EOF'
<button type="button" class="bg-gray-200 px-2 py-1" {{on "click" this.toggle}}>
  🐞 Debug {{if this.enabled "ON" "OFF"}}
</button>
EOF

### 7. GitHub Actions CI
mkdir -p .github/workflows && cat > .github/workflows/test.yml <<'EOF'
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - run: pnpm install
      - run: pnpm exec ember test
EOF

### 8. Add aria and accessibility helpers
cat > app/components/ui-box.gts <<'EOF'
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

export default class UiBoxComponent extends Component {
  @tracked query = '';

  get filteredNames() {
    const q = this.query.toLowerCase();
    return this.args.names.map((item) => {
      let text = item.text;
      if (q && text.toLowerCase().includes(q)) {
        text = text.replace(new RegExp(`(${q})`, 'ig'), '<mark>$1</mark>');
      }
      return { id: item.id, html: text };
    });
  }

  @action updateQuery(e) {
    this.query = e.target.value;
  }
}
EOF

cat > app/components/ui-box.hbs <<'EOF'
<div class="p-4 bg-white rounded shadow-md space-y-4" role="search">
  <label for="search" class="block text-sm font-medium">🔎 Search:</label>
  <input
    id="search"
    type="text"
    class="border px-3 py-2 w-full"
    placeholder="Try Alice, Bob, etc."
    value={{this.query}}
    aria-label="Search input"
    {{on "input" this.updateQuery}}
  />

  <ul role="list" aria-live="polite">
    {{#each this.filteredNames as |item|}}
      <li class="border rounded p-2" aria-label="Result">{{{item.html}}}</li>
    {{/each}}
  </ul>

  <DebugToggle />
</div>
EOF

### ✅ Done
pnpm exec ember test

echo "\n✅ V16 complete: Polarion-ready baseline applied."

### Git commit
git add .
git commit -m "v16: Polarion-ready baseline with TS, Tailwind, Mirage, CI, Debug"
git push
