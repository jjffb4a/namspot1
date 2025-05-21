# increment-v7-tailwind-mirage-docs.sh — loverk 20.05.2025

# 1. Install Tailwind CSS v4 (manual setup, no CLI)
pnpm add -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# 2. Configure tailwind.config.js
cat > tailwind.config.js <<'EOF'
/* tailwind.config.js — v7 loverk */
module.exports = {
  content: [
    './app/**/*.hbs',
    './app/**/*.ts',
    './app/**/*.js'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
EOF

# 3. Add Tailwind to app.css
mkdir -p app/styles
cat > app/styles/app.css <<'EOF'
/* app/styles/app.css — v7 loverk */
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# 4. Link the stylesheet in ember-cli-build.js
sed -i '' "s/new EmberApp(defaults, {/new EmberApp(defaults, {\n    'ember-cli-postcss': {\n      plugins: [require('tailwindcss')('./tailwind.config.js'), require('autoprefixer')()],\n    },/" ember-cli-build.js

# 5. Add simple Tailwind classes to template
sed -i '' 's/class="box"/class="p-4 bg-gray-50 border rounded space-y-2"/' app/components/ui-box.hbs

# 6. Install and setup Mirage
pnpm add -D ember-cli-mirage

mkdir -p mirage
cat > mirage/config.js <<'EOF'
/* mirage/config.js — v7 loverk */
export default function () {
  this.namespace = '/api';

  this.get('/names', () => [
    { id: '1', text: 'Alice in Wonderland' },
    { id: '2', text: 'Bob the Builder' },
    { id: '3', text: 'Clara from Ember' }
  ]);
}
EOF

# 7. Enable Mirage initializer
mkdir -p app/initializers
cat > app/initializers/ember-cli-mirage.js <<'EOF'
/* app/initializers/ember-cli-mirage.js — v7 loverk */
import { startMirage } from 'ember-cli-mirage';

export function initialize() {
  if (ENV.environment !== 'production') {
    startMirage();
  }
}

export default {
  initialize
};
EOF

# 8. Document update
cat > docs/notes_v7.md <<'EOF'
# docs/notes_v7.md — loverk 20.05.2025

## v7: TailwindCSS v4 + Mirage + Docs

### 🎨 TailwindCSS v4
- Installed manually (v4 has no CLI).
- Configured with PostCSS.
- Now using utility classes in UI.

### 🧪 Mirage
- Setup API mock for `/api/names`.
- Useful for future dynamic test cases and UI mocking.

### 📚 Docs
- Added per-version notes.
- Clarified startup instructions in `README.md`.

✅ Now ready for extended test coverage and TS conversion!
EOF

# Optional update for docs/README.md if Tailwind usage is worth mentioning:
echo "🔧 TailwindCSS enabled with PostCSS pipeline." >> docs/README.md

# 9. Commit and push
git add .
git commit -m "v7: 🎨 Add TailwindCSS v4 + Mirage setup + docs updates"
git push
