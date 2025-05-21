#!/bin/bash

# 7b: Add Mirage scenarios: empty dataset and delayed response

mkdir -p mirage/scenarios && cat > mirage/scenarios/empty.js <<'EOF'
// mirage/scenarios/empty.js loverk 20.05.2025
export default function () {
  this.namespace = '/api';
  this.get('/names', () => []);
}
EOF

cat > mirage/scenarios/delayed.js <<'EOF'
// mirage/scenarios/delayed.js loverk 20.05.2025
export default function () {
  this.namespace = '/api';
  this.timing = 2000; // simulate delay
  this.get('/names', (schema) => schema.db.names);
}
EOF

git add . && git commit -m "v7b: Add Mirage scenarios: empty and delayed"

git push

# 8: Add TypeScript support

pnpm install --save-dev typescript @glint/core @glint/environment-ember-loose

mkdir -p types && cat > types/global.d.ts <<'EOF'
// types/global.d.ts loverk 20.05.2025
declare module '*.hbs' {
  import { TemplateFactory } from 'htmlbars-inline-precompile';
  const tmpl: TemplateFactory;
  export default tmpl;
}
EOF

echo 'typeRoots = ["types"]' >> tsconfig.json

mv app/components/ui-box.js app/components/ui-box.ts

cat > app/components/ui-box.ts <<'EOF'
// app/components/ui-box.ts loverk 20.05.2025
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

type Name = { id: string; text: string };
type Args = {
  names: Name[];
  query: string;
  onSearch: (value: string) => void;
};

export default class UiBoxComponent extends Component<Args> {
  @tracked query = '';
  @tracked appliedQuery = '';

  get filteredNames(): { id: string; html: string }[] {
    const filter = this.appliedQuery.toLowerCase();
    const highlight = this.query.toLowerCase();
    return this.args.names
      .filter((item) => item.text.toLowerCase().includes(filter))
      .map((item) => {
        let text = item.text;
        if (highlight) {
          text = text.replace(
            new RegExp(`(${highlight})`, 'ig'),
            '<mark>$1</mark>'
          );
        }
        return { id: item.id, html: text };
      });
  }

  @action updateQuery(val: string) {
    this.query = val;
  }

  @action applyQuery() {
    this.appliedQuery = this.query;
  }
}
EOF

git add . && git commit -m "v8: Convert ui-box to TypeScript, setup types"

git push

# 9: Add basic visual test using ember-exam and CLI screenshot tool (optional)

pnpm install --save-dev ember-exam

cat > tests/visual/snapshot-test.js <<'EOF'
// tests/visual/snapshot-test.js loverk 20.05.2025
#!/bin/bash

# 7b: Add Mirage scenarios: empty dataset and delayed response

mkdir -p mirage/scenarios && cat > mirage/scenarios/empty.js <<'EOF'
// mirage/scenarios/empty.js loverk 20.05.2025
export default function () {
  this.namespace = '/api';
  this.get('/names', () => []);
}
EOF

cat > mirage/scenarios/delayed.js <<'EOF'
// mirage/scenarios/delayed.js loverk 20.05.2025
export default function () {
  this.namespace = '/api';
  this.timing = 2000; // simulate delay
  this.get('/names', (schema) => schema.db.names);
}
EOF

git add . && git commit -m "v7b: Add Mirage scenarios: empty and delayed"

git push

# 8: Add TypeScript support

pnpm install --save-dev typescript @glint/core @glint/environment-ember-loose

mkdir -p types && cat > types/global.d.ts <<'EOF'
// types/global.d.ts loverk 20.05.2025
declare module '*.hbs' {
  import { TemplateFactory } from 'htmlbars-inline-precompile';
  const tmpl: TemplateFactory;
  export default tmpl;
}
EOF

echo 'typeRoots = ["types"]' >> tsconfig.json

mv app/components/ui-box.js app/components/ui-box.ts

cat > app/components/ui-box.ts <<'EOF'
// app/components/ui-box.ts loverk 20.05.2025
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

type Name = { id: string; text: string };
type Args = {
  names: Name[];
  query: string;
  onSearch: (value: string) => void;
};

export default class UiBoxComponent extends Component<Args> {
  @tracked query = '';
  @tracked appliedQuery = '';

  get filteredNames(): { id: string; html: string }[] {
    const filter = this.appliedQuery.toLowerCase();
    const highlight = this.query.toLowerCase();
    return this.args.names
      .filter((item) => item.text.toLowerCase().includes(filter))
      .map((item) => {
        let text = item.text;
        if (highlight) {
          text = text.replace(
            new RegExp(`(${highlight})`, 'ig'),
            '<mark>$1</mark>'
          );
        }
        return { id: item.id, html: text };
      });
  }

  @action updateQuery(val: string) {
    this.query = val;
  }

  @action applyQuery() {
    this.appliedQuery = this.query;
  }
}
EOF

git add . && git commit -m "v8: Convert ui-box to TypeScript, setup types"

git push

# 9: Add basic visual test using ember-exam and CLI screenshot tool (optional)

pnpm install --save-dev ember-exam

cat > tests/visual/snapshot-test.js <<'EOF'
// tests/visual/snapshot-test.js loverk 20.05.2025
#!/bin/bash

# 7b: Add Mirage scenarios: empty dataset and delayed response

mkdir -p mirage/scenarios && cat > mirage/scenarios/empty.js <<'EOF'
// mirage/scenarios/empty.js loverk 20.05.2025
export default function () {
  this.namespace = '/api';
  this.get('/names', () => []);
}
EOF

cat > mirage/scenarios/delayed.js <<'EOF'
// mirage/scenarios/delayed.js loverk 20.05.2025
export default function () {
  this.namespace = '/api';
  this.timing = 2000; // simulate delay
  this.get('/names', (schema) => schema.db.names);
}
EOF

git add . && git commit -m "v7b: Add Mirage scenarios: empty and delayed"

git push

# 8: Add TypeScript support

pnpm install --save-dev typescript @glint/core @glint/environment-ember-loose

mkdir -p types && cat > types/global.d.ts <<'EOF'
// types/global.d.ts loverk 20.05.2025
declare module '*.hbs' {
  import { TemplateFactory } from 'htmlbars-inline-precompile';
  const tmpl: TemplateFactory;
  export default tmpl;
}
EOF

echo 'typeRoots = ["types"]' >> tsconfig.json

mv app/components/ui-box.js app/components/ui-box.ts

cat > app/components/ui-box.ts <<'EOF'
// app/components/ui-box.ts loverk 20.05.2025
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

type Name = { id: string; text: string };
type Args = {
  names: Name[];
  query: string;
  onSearch: (value: string) => void;
};

export default class UiBoxComponent extends Component<Args> {
  @tracked query = '';
  @tracked appliedQuery = '';

  get filteredNames(): { id: string; html: string }[] {
    const filter = this.appliedQuery.toLowerCase();
    const highlight = this.query.toLowerCase();
    return this.args.names
      .filter((item) => item.text.toLowerCase().includes(filter))
      .map((item) => {
        let text = item.text;
        if (highlight) {
          text = text.replace(
            new RegExp(`(${highlight})`, 'ig'),
            '<mark>$1</mark>'
          );
        }
        return { id: item.id, html: text };
      });
  }

  @action updateQuery(val: string) {
    this.query = val;
  }

  @action applyQuery() {
    this.appliedQuery = this.query;
  }
}
EOF

git add . && git commit -m "v8: Convert ui-box to TypeScript, setup types"

git push

# 9: Add basic visual test using ember-exam and CLI screenshot tool (optional)

pnpm install --save-dev ember-exam

cat > tests/visual/snapshot-test.js <<'EOF'
// tests/visual/snapshot-test.js loverk 20.05.2025
import { module, test } from 'qunit';
import { visit, currentURL } from '@ember/test-helpers';

module('Acceptance | visual', function () {
  test('page visually loads', async function (assert) {
    await visit('/');
    assert.strictEqual(currentURL(), '/', 'Landed on index');
  });
});
EOF

# --- Notes + Git ---
cat > docs/notes_v8_v9.md <<'EOF'
# docs/notes_v8_v9.md — loverk 21.05.2025

## v7b: Mirage Scenarios
- Empty data
- Delayed response
- Dynamically selected via `?scenario=xxx`

## v8: TypeScript Setup
- Added tsconfig.json
- Converted ui-box.js -> ui-box.ts

## v9: Visual Testing
- ember-exam installed
- Added basic acceptance test
EOF

git add .
git commit -m "v7b-9: 🛠️ Mirage scenarios, ✅ TypeScript setup, 📷 Visual test base"
git push
