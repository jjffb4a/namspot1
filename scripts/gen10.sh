#!/bin/bash

# v10 - Convert Namspot1 to Polarion-like structure (20.05.2025 loverk)

set -euo pipefail

STEP="v10"
MSG="${STEP}: Convert to Polarion project structure"
echo "\n🔧 $MSG"

echo "📁 Creating Polarion-style structure..."
mkdir -p app/components/ui-box app/styles docs/polarion
mv app/components/ui-box.js app/components/ui-box/component.js
mv app/components/ui-box.hbs app/components/ui-box/template.hbs

# Restructure tests
mkdir -p tests/integration/components/ui-box
mv tests/components/ui-box-*.js tests/integration/components/ui-box/

# Move and rename notes
mv docs/notes_v9.md docs/polarion/notes_polarion.md

# Optional: Add a Polarion readme
cat > docs/polarion/README.md <<'EOF'
# Polarion Format Migration (v10)

Namspot1 has now been restructured for Polarion-like conventions:

- Components live in `app/components/<name>/component.js`
- Templates in `app/components/<name>/template.hbs`
- Tests moved under `tests/integration/components/<name>/`

This prepares the project for larger-scale engineering environments and aligns with modularity and traceability goals.
EOF

# Optional: Add app reference index
cat > docs/polarion/index.json <<'EOF'
{
  "app": "namspot1",
  "version": "v10",
  "structure": "polarion-compatible",
  "components": ["ui-box"],
  "tests": "integration/components/ui-box"
}
EOF

# Update README if needed
if ! grep -q "Polarion" docs/README.md; then
  echo "\n### 📁 Structure" >> docs/README.md
  echo "- Now supports Polarion-style layout under \`app/components/name/\`" >> docs/README.md
fi

# Git commit and push

git add .
git commit -m "$MSG"
git push

echo "✅ Done: $MSG"
