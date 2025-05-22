# increment-v6-embroider-polarion.sh — loverk 20.05.2025

# 1. Enable Embroider via build config
cat > ember-cli-build.js <<'EOF'
/* ember-cli-build.js — v6 loverk 20.05.2025 */
'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const { Webpack } = require('@embroider/webpack');
const { compatBuild } = require('@embroider/compat');

module.exports = function (defaults) {
  const app = new EmberApp(defaults, {
    // standard options
  });

  return compatBuild(app, Webpack, {
    staticAppPaths: [],
    skipBabel: [
      {
        package: 'qunit',
      },
    ],
  });
};
EOF

# 2. Install Embroider dependencies
pnpm add -D @embroider/core @embroider/webpack @embroider/compat

# 3. Add future-oriented folder structure for Polarion-style architecture
mkdir -p app/modules
mkdir -p app/modules/core
mkdir -p app/modules/features

# Move or mirror existing components to modular structure
mkdir -p app/modules/features/ui-box
cp app/components/ui-box.ts app/modules/features/ui-box/component.ts
cp app/templates/components/ui-box.hbs app/modules/features/ui-box/template.hbs

# 4. Create a "feature entry point"
cat > app/modules/features/ui-box/index.ts <<'EOF'
/* app/modules/features/ui-box/index.ts — v6 loverk */
export { default } from './component';
export { default as template } from './template.hbs';
EOF

# 5. Update resolver (optional for advanced Polarion setups)

# 6. Add new version notes
cat > docs/notes_v6.md <<'EOF'
# docs/notes_v6.md — loverk 20.05.2025

## v6: Embroider + Polarion-style Conversion

### 🔧 Embroider
- Enabled Embroider build pipeline with `@embroider/webpack`.
- Ensures compatibility with modern build tools and tree-shaking.

### 🧩 Polarion Architecture Start
- Created `/modules/features/ui-box` to represent domain-driven components.
- Entry points (`index.ts`) facilitate standalone testing and lazy loading.

🔜 Future enhancements may include routing per module, code splitting, and per-feature services.
EOF

# 7. Commit & push
git add .
git commit -m "v6: 🧱 Add Embroider + modular architecture for Polarion prep"
git push
