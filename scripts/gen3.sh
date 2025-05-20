# increment-v3-tailwind.sh — loverk 20.05.2025

# 1. Add required packages
pnpm add -D tailwindcss@next postcss@latest autoprefixer@latest

# 2. Initialize Tailwind config
npx tailwindcss init -p

# 3. Generate main stylesheet and add Tailwind directives
mkdir -p app/styles && cat > app/styles/app.css <<'EOF'
/* app/styles/app.css — Tailwind base setup */
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# 4. Patch ember-cli-build.js to include Tailwind CSS
sed -i '' '/module.exports = function/ a\
  const path = require("path");\
  const fs = require("fs");
' ember-cli-build.js

sed -i '' '/app.import.*app.css.*/d' ember-cli-build.js
sed -i '' '/return app.toTree();/i\
  app.import("app/styles/app.css");
' ember-cli-build.js

# 5. Add Tailwind content configuration
cat > tailwind.config.js <<'EOF'
/** tailwind.config.js — loverk 20.05.2025 */
module.exports = {
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

# 6. Add Tailwind to package.json postcss config if needed
cat > postcss.config.js <<'EOF'
/** postcss.config.js — loverk 20.05.2025 */
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
EOF

# 7. Add Tailwind usage to app/templates/application.hbs
sed -i '' '1s;^;<div class="prose mx-auto p-6 font-sans text-base">\n;' app/templates/application.hbs
echo "</div>" >> app/templates/application.hbs

# 8. Add Tailwind styling to UiBox for demo
sed -i '' 's/class="box"/class="p-4 border rounded shadow space-y-4 bg-white"/' app/templates/components/ui-box.hbs
sed -i '' 's/<label>/<label class="text-gray-700 font-medium text-sm">/' app/templates/components/ui-box.hbs
sed -i '' 's/<input/<input class="border rounded px-3 py-2 w-full"/' app/templates/components/ui-box.hbs
sed -i '' 's/<ul>/<ul class="space-y-2">/' app/templates/components/ui-box.hbs
sed -i '' 's/<li>/<li class="p-2 rounded border bg-gray-50 text-sm">/' app/templates/components/ui-box.hbs

# 9. Add note
mkdir -p docs && cat > docs/notes_v3.md <<'EOF'
# docs/notes_v3.md — loverk 20.05.2025

## v3: Tailwind CSS v4 Integration

- Installed Tailwind 4 with PostCSS setup.
- Configured `tailwind.config.js` and `postcss.config.js`.
- Added `app/styles/app.css` with Tailwind directives.
- Applied Tailwind classes to `<UiBox />` layout for polish.
- Wrapping container uses `.prose` and `mx-auto` for structure.

🛠️ Next: Add Mirage and test scenarios in `v4`.
EOF

# 10. Commit changes
git add .
git commit -m "v3: 🎨 Tailwind CSS v4 added and styled UiBox"
git push
