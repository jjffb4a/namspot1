# scripts/patch_v15_all.sh loverk 20.05.2025
mkdir -p scripts && cat > scripts/patch_v15_all.sh <<'EOF'
#!/bin/bash
set -e

echo "🔧 [v15.1] Setting up Husky + Lint-Staged pre-commit hook..."

pnpm add -D husky lint-staged

npx husky install
pnpm set-script prepare "husky install"
npx husky add .husky/pre-commit "npx lint-staged"

cat > .lintstagedrc.json <<'EOL'
{
  "*.{js,ts,hbs}": ["eslint --fix", "git add"]
}
EOL

git add .husky .lintstagedrc.json package.json
git commit -m "v15.1: Add Husky + lint-staged for pre-commit checks"
git push

echo "✅ Husky + Lint-Staged configured."


echo "🎨 [v15.2] Adding Percy snapshot visual testing..."

pnpm add -D @percy/cli @percy/storybook

mkdir -p .percy
echo '{}' > .percy/config.yml

pnpm set-script snapshot "percy snapshot"

git add .percy package.json
git commit -m "v15.2: Add Percy snapshot setup"
git push

echo "✅ Percy snapshot support added."


echo "📊 [v15.3] Adding test coverage with nyc..."

pnpm add -D nyc

cat > .nycrc.json <<'EOL'
{
  "extension": [".js", ".ts"],
  "reporter": ["text", "html"],
  "exclude": ["tests/", "mirage/", "docs/"]
}
EOL

pnpm set-script coverage "nyc --reporter=lcov pnpm exec ember test"

git add .nycrc.json package.json
git commit -m "v15.3: Add nyc for test coverage"
git push

echo "✅ NYC coverage setup completed."


echo "📝 Writing docs/notes_v15.md..."
mkdir -p docs && cat > docs/notes_v15.md <<'EON'
# v15 – Tooling Enhancements

## ✅ v15.1 Pre-commit Hooks

- Uses Husky to enforce code linting before commit.
- Runs lint-staged for *.js, *.ts, *.hbs files.
- Prevents bad commits via `.husky/pre-commit`.

## ✅ v15.2 Visual Snapshot Testing

- Percy CLI setup for future snapshot testing
- Run with: pnpm run snapshot

## ✅ v15.3 Test Coverage

- Added nyc (Istanbul) for test coverage tracking.
- Run with: pnpm run coverage
- Excludes tests/, mirage/, and docs/

EON

echo "🎉 All patches for v15 applied."
EOF
