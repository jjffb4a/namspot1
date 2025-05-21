pnpm add -D chokidar-cli

mkdir -p scripts && cat > scripts/dev-watch.sh <<'EOF'
#!/bin/bash
# scripts/dev-watch.sh  loverk 20.05.2025
echo "👀 Watching for file changes..."

chokidar "app/**/*" "tests/**/*" "config/**/*" -c '
  echo "🔁 Change detected: running tests..."
  pnpm exec ember test &&
  echo "✅ Tests passed, pushing..." &&
  git add . &&
  git commit -m "Auto: changes + passed tests" &&
  git push
'
EOF

chmod +x scripts/dev-watch.sh
git add scripts/dev-watch.sh
git commit -m "v12: Add dev-watch auto test & push script"
git push
