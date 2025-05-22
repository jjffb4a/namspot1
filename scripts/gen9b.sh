#!/bin/bash
# scripts/patch-v9-autotest-push.sh  loverk 21.05.2025

echo "🔁 Setting up V9 auto-test & git-push system..."

mkdir -p scripts

cat > scripts/watch-and-push.sh <<'EOF'
#!/bin/bash
# scripts/watch-and-push.sh  loverk 21.05.2025

echo "🔁 V9: Watching for changes (Ember app, including public/, pnpm-lock.yaml)..."

WATCHED_FILES=$(find app addon public tests -type f -name '*.js' -o -name '*.ts' -o -name '*.hbs')
WATCHED_FILES+=" pnpm-lock.yaml"

LAST_HASH=""

while true; do
  NEW_HASH=$(find $WATCHED_FILES | xargs cat | shasum)

  if [[ "$NEW_HASH" != "$LAST_HASH" ]]; then
    echo "🔁 Change detected at $(date '+%H:%M:%S')"

    pnpm install
    if pnpm exec ember test; then
      echo "✅ Tests passed, pushing..."
      git add .
      git commit -m "V9 auto: changes + passed tests @ $(date '+%Y-%m-%d %H:%M:%S')"
      git push
    else
      echo "❌ Tests failed. Fix before committing."
    fi

    LAST_HASH="$NEW_HASH"
  fi

  sleep 3
done
EOF

chmod +x scripts/watch-and-push.sh

git add .
git commit -m "V9: Auto watcher script for CI-like local testing and push"
git push

echo "✅ V9 script ready. Run with:"
echo "  ./scripts/watch-and-push.sh"
