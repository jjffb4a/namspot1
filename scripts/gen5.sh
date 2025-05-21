# increment-v5-typescript.sh — loverk 20.05.2025

# 1. Rename relevant files to .ts
mv app/components/ui-box.js app/components/ui-box.ts
mv app/services/name-loader.js app/services/name-loader.ts
mv app/initializers/ember-cli-mirage.js app/initializers/ember-cli-mirage.ts

# 2. Adjust TypeScript syntax in component
cat > app/components/ui-box.ts <<'EOF'
/* app/components/ui-box.ts — loverk 20.05.2025 */
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';
import type NameLoaderService from 'namspot1/services/name-loader';

interface Name {
  id: string;
  text: string;
}

interface UiBoxArgs {
  query: string;
  onSearch: (val: string) => void;
  names?: Name[];
}

export default class UiBoxComponent extends Component<UiBoxArgs> {
  @tracked query = '';
  @tracked appliedQuery = '';
  @service declare nameLoader: NameLoaderService;

  names: Name[] = [];

  constructor(owner: unknown, args: UiBoxArgs) {
    super(owner, args);
    this.query = args.query || '';
    this.nameLoader.load();
    this.names = this.nameLoader.names;
  }

  get filteredNames() {
    const filter = this.appliedQuery.toLowerCase();
    const highlight = this.query.toLowerCase();
    return this.args.names ?? this.names
      .filter((item) => item.text.toLowerCase().includes(filter))
      .map((item) => {
        let text = item.text;
        if (highlight) {
          text = text.replace(new RegExp(`(${highlight})`, 'ig'), '<mark>$1</mark>');
        }
        return { id: item.id, html: text };
      });
  }

  @action
  updateQuery(val: string) {
    this.query = val;
  }

  @action
  applyQuery() {
    this.appliedQuery = this.query;
  }
}
EOF

# 3. Update name-loader.ts
cat > app/services/name-loader.ts <<'EOF'
/* app/services/name-loader.ts — loverk 20.05.2025 */
import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

interface Name {
  id: string;
  text: string;
}

export default class NameLoaderService extends Service {
  @tracked names: Name[] = [];

  async load(): Promise<void> {
    try {
      const res = await fetch('/api/names');
      const json: Name[] = await res.json();
      this.names = json;
    } catch (e) {
      console.error('❌ Name loading failed:', e);
    }
  }
}
EOF

# 4. Update initializer
cat > app/initializers/ember-cli-mirage.ts <<'EOF'
/* app/initializers/ember-cli-mirage.ts — loverk 20.05.2025 */
import config from 'namspot1/config/environment';
import startMirage from 'ember-cli-mirage/start';

export function initialize(): void {
  if (config.environment === 'development' || config.environment === 'test') {
    startMirage();
  }
}

export default {
  initialize,
};
EOF

# 5. Add types to test (optional)
# For clarity and safety, types can be added to test helpers in a later step

# 6. Add version notes
cat > docs/notes_v5.md <<'EOF'
# docs/notes_v5.md — loverk 20.05.2025

## v5: TypeScript Migration

### ✅ Key Updates
- All main logic files migrated to `.ts`
- Types added for component args, service data, and method signatures.
- `@service` injection uses `declare`.

🛡️ Ensures compile-time safety and future scalability.
EOF

# 7. Commit and push
git add .
git commit -m "v5: 🔁 Migrate component/service/initializer to TypeScript"
git push
