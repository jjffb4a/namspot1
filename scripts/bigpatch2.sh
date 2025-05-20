#!/bin/bash
# namspot1_dev_steps.sh — loverk 20.05.2025

# STEP 1 — Basic CSS Enhancement
mkdir -p app/styles && cat > app/styles/app.css <<'EOF'
/* app/styles/app.css loverk 20.05.2025 */
body {
  font-family: system-ui, sans-serif;
  margin: 2rem;
  background: #fdfdfd;
  color: #111;
}
label {
  font-weight: bold;
}
input {
  padding: 0.4rem;
  margin-top: 0.5rem;
  display: block;
  width: 100%;
  max-width: 300px;
  border: 1px solid #ccc;
}
ul {
  margin-top: 1rem;
  list-style: none;
  padding: 0;
}
li {
  padding: 0.25rem;
  background: #eef;
  margin-bottom: 0.2rem;
}
mark {
  background: yellow;
}
EOF

git add . && git commit -m "v1: 💄 Basic CSS enhancements" && git push


# STEP 2 — Add Debug Mode Dropdown (and component state for it)
mkdir -p app/components && cat > app/components/debug-toggle.js <<'EOF'
/* app/components/debug-toggle.js loverk 20.05.2025 */
import Component from '@glimmer/component';
import { action } from '@ember/object';

export default class DebugToggleComponent extends Component {
  @action
  toggleLogging(event) {
    console.log('[debug-toggle] mode changed:', event.target.value);
  }
}
EOF

cat > app/components/debug-toggle.hbs <<'EOF'
<!-- app/components/debug-toggle.hbs loverk 20.05.2025 -->
<div>
  <label for="debug">Debug Mode:</label>
  <select id="debug" {{on "change" this.toggleLogging}}>
    <option value="off">Off</option>
    <option value="basic">Basic Logs</option>
    <option value="verbose">Verbose</option>
  </select>
</div>
EOF

git checkout -b debug-mode
git add . && git commit -m "v2: 🐛 Add debug toggle component" && git push --set-upstream origin debug-mode


# STEP 3 — Install Tailwind v4 (PostCSS setup)
pnpm add -D tailwindcss@next postcss autoprefixer
npx tailwindcss init -p

cat > tailwind.config.js <<'EOF'
/* tailwind.config.js loverk 20.05.2025 */
module.exports = {
  content: ['./app/**/*.{hbs,js,ts}'],
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

git checkout -b tailwind
git add . && git commit -m "v3: 🌈 Add Tailwind v4 with PostCSS config" && git push --set-upstream origin tailwind


# STEP 4 — Add MirageJS & expand test coverage
pnpm add -D ember-cli-mirage
mkdir -p mirage && cat > mirage/config.js <<'EOF'
export default function() {
  this.namespace = '/api';
  this.get('/names', () => [
    { id: '1', text: 'Alice in Wonderland' },
    { id: '2', text: 'Bob the Builder' },
    { id: '3', text: 'Clara Oswald' }
  ]);
}
EOF

mkdir -p tests/acceptance && cat > tests/acceptance/name-list-test.js <<'EOF'
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';
import { visit, currentURL } from '@ember/test-helpers';

module('Acceptance | name list', function(hooks) {
  setupApplicationTest(hooks);

  test('it loads names via mirage', async function(assert) {
    await visit('/');
    assert.strictEqual(currentURL(), '/');
    assert.dom('ul li').exists({ count: 3 });
  });
});
EOF

git checkout -b mirage-and-tests
git add . && git commit -m "v4: 🧪 Add Mirage and acceptance test coverage" && git push --set-upstream origin mirage-and-tests


# STEP 5 — Convert to TypeScript (patching components/services)
pnpm add -D ember-cli-typescript

find app/components -name '*.js' | while read -r file; do
  mv "$file" "${file%.js}.ts"
done

# NOTE: You may want to update `ember-cli-build.js` or `tsconfig.json` accordingly

git checkout -b typescript
git add . && git commit -m "v5: 🔁 Convert components to TypeScript" && git push --set-upstream origin typescript


# STEP 6 — Setup Polarion-style integration (placeholder)
# (Assumes use of Polarion's test case export or JSON mock format)

mkdir -p polarion && cat > polarion/mock-polarion-export.json <<'EOF'
{
  "testCases": [
    { "id": "TC01", "title": "Render name list", "status": "automated" },
    { "id": "TC02", "title": "Highlight names", "status": "automated" }
  ]
}
EOF

git checkout -b polarion-integration
git add . && git commit -m "v6: 🧩 Add Polarion export mock" && git push --set-upstream origin polarion-integration

echo "✅ All steps completed. Branches created, committed, and pushed."
