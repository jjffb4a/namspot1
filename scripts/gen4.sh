# increment-v4-mirage-tests.sh — loverk 20.05.2025

# 1. Install Mirage
pnpm add -D ember-cli-mirage

# 2. Generate Mirage directory and config
mkdir -p mirage && cat > mirage/config.js <<'EOF'
/* mirage/config.js — loverk 20.05.2025 */
export default function () {
  this.namespace = '/api';

  this.get('/names', () => {
    return [
      { id: '1', text: 'Alice in Wonderland' },
      { id: '2', text: 'Bob the Builder' },
      { id: '3', text: 'Clara from Emberland' },
      { id: '4', text: 'Dora the Explorer' },
    ];
  });
}
EOF

# 3. Create initializer to start Mirage
mkdir -p app/initializers && cat > app/initializers/ember-cli-mirage.js <<'EOF'
/* app/initializers/ember-cli-mirage.js — loverk 20.05.2025 */
import config from 'namspot1/config/environment';
import startMirage from 'ember-cli-mirage/start';

export function initialize() {
  if (config.environment === 'development' || config.environment === 'test') {
    startMirage();
  }
}

export default {
  initialize,
};
EOF

# 4. Add service to load names
mkdir -p app/services && cat > app/services/name-loader.js <<'EOF'
/* app/services/name-loader.js — loverk 20.05.2025 */
import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class NameLoaderService extends Service {
  @tracked names = [];

  async load() {
    try {
      const res = await fetch('/api/names');
      const json = await res.json();
      this.names = json;
      console.log('[NameLoader] loaded:', this.names);
    } catch (e) {
      console.error('❌ Name loading failed:', e);
    }
  }
}
EOF

# 5. Inject name-loader in UiBox component
sed -i '' '1 a\
import { inject as service } from "@ember/service";' app/components/ui-box.js
sed -i '' '2 a\
@service nameLoader;' app/components/ui-box.js
sed -i '' '/constructor(owner, args)/ a\
    this.nameLoader.load();\
    this.names = this.nameLoader.names;  // Optional live tracking\
' app/components/ui-box.js

# 6. Create test using Mirage data
mkdir -p tests/integration/components && cat > tests/integration/components/ui-box-mirage-test.js <<'EOF'
/* tests/integration/components/ui-box-mirage-test.js — loverk 20.05.2025 */
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, waitFor } from '@ember/test-helpers';
import { hbs } from 'ember-cli-htmlbars';

module('Integration | Component | ui-box | Mirage', function (hooks) {
  setupRenderingTest(hooks);

  test('renders Mirage-loaded names', async function (assert) {
    await render(hbs`<UiBox />`);
    await waitFor('ul li');
    assert.dom('ul li').exists({ count: 4 }, '4 items from Mirage shown');
  });
});
EOF

# 7. Add note
cat > docs/notes_v4.md <<'EOF'
# docs/notes_v4.md — loverk 20.05.2025

## v4: Add Mirage + Test Scenarios

### ✅ Features Added
- Integrated `ember-cli-mirage` with custom endpoint `/api/names`.
- Service `name-loader` fetches and tracks names.
- `<UiBox />` uses service on startup.
- Test loads `UiBox` and validates rendering Mirage data.

🧪 Prepares base for testing dynamic/mock-driven UI with data fallback.

Next: convert to TypeScript (v5)
EOF

# 8. Commit changes
git add .
git commit -m "v4: ✨ Mirage API added + mock-driven test case"
git push
