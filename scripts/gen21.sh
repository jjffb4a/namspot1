#!/bin/bash
# scripts/gen21.sh loverk 24.05.2025

# V21: Auto-dev loop with CI-friendly test + push on file changes

WATCH_SCRIPT="scripts/watch-and-commit.sh"

echo "🛠️ Creating auto-watch script for dev workflow..."

mkdir -p scripts && cat > "$WATCH_SCRIPT" <<'EOF'
#!/bin/bash
# scripts/watch-and-commit.sh loverk 24.05.2025

echo "🔁 Auto-watch and push loop running..."
echo "ℹ️ Stop with Ctrl+C"

# Ignore changes in these
EXCLUDE="node_modules|tmp|dist|coverage|.git|pnpm-lock.yaml"

# Use fswatch or entr depending on platform
WATCH_CMD=$(command -v fswatch || command -v entr)

if [[ -z "$WATCH_CMD" ]]; then
  echo "❌ Please install fswatch or entr"
  exit 1
fi

WATCH_TARGET=$(find . -type f ! -path "./node_modules/*" ! -path "./tmp/*" ! -path "./dist/*" ! -name "pnpm-lock.yaml")

while true; do
  echo "$WATCH_TARGET" | entr -d sh -c '
    echo "🔍 Change detected!"
    echo "🧪 Running tests..."
    if pnpm exec ember test; then
      echo "✅ Tests passed. Committing..."
      git add .
      git commit -m "🔁 Auto-commit: changes + passed tests [V21]"
      git push
    else
      echo "❌ Tests failed. Changes NOT committed."
    fi
  '
done
EOF

# Ask to make the watcher script executable
echo -n "❓ Make watch script executable with chmod +x? [y/N] "
read confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  chmod +x "$WATCH_SCRIPT"
  echo "✅ Script is now executable: $WATCH_SCRIPT"
else
  echo "ℹ️ Skipped chmod. You can run it manually if needed."
fi

echo "✅ V21 complete: Watch and auto-push script created."
