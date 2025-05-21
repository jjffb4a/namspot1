#!/bin/bash
# scripts/dev-watch.sh loverk 21.05.2025 — smart CI-like local watcher with auto test + optional push

echo "🚀 Watching for changes in source, tests, configs, public assets..."

chokidar "app/**/*" "tests/**/*" "config/**/*" "public/**/*" \
         "package.json" "pnpm-lock.yaml" "ember-cli-build.js" "testem.js" \
  -c '
    echo "🔁 Change detected: running tests..."

    # If package.json or lockfile changed, reinstall
    if git diff --name-only | grep -E "package.json|pnpm-lock.yaml" > /dev/null; then
      echo "📦 package.json changed — running pnpm install..."
      pnpm install
    fi

    # Run tests
    if pnpm exec ember test; then
      echo "✅ Tests passed."

      # Confirm before pushing
      read -p "💬 Push changes to GitHub? (y/n): " yn
      if [[ "$yn" == "y" ]]; then
        git add .
        git commit -m "Auto: changes + passed tests"
        git push
      else
        echo "⏭️  Skipping push."
      fi
    else
      echo "❌ Tests failed. Fix issues before pushing."
    fi
  '
