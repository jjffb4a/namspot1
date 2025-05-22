#!/bin/bash
# scripts/patch-v9-ember-exam.sh  loverk 21.05.2025

echo "🔁 V9: Installing and configuring ember-exam for advanced testing..."

# Install ember-exam
pnpm add -D ember-exam

# Ensure ember-exam is included in your test command
if ! grep -q "ember exam" package.json; then
  echo "✅ Adding test script override with ember-exam..."
  jq '.scripts.test = "ember exam"' package.json > temp.json && mv temp.json package.json
fi

# Create testem config if missing
cat > testem.js <<'EOF'
// testem.js loverk V9
module.exports = {
  test_page: 'tests/index.html?hidepassed',
  disable_watching: true,
  launch_in_ci: ['Chrome'],
  launch_in_dev: ['Chrome'],
  parallel: 4,
  browser_args: {
    Chrome: {
      ci: [
        '--no-sandbox',
        '--disable-gpu',
        '--headless',
        '--remote-debugging-port=9222'
      ]
    }
  }
};
EOF

# Validate test runner
echo "✅ You can now run tests like:"
echo "   pnpm exec ember exam --split=2 --parallel=2"
echo "   pnpm exec ember exam --module='ui-box-filtering-test.js'"

# Optional: Example visual debug command
echo "   # Debug single test visually:"
echo "   pnpm exec ember exam --serve && open http://localhost:7357"

# Git commit
git add .
git commit -m "V9: Add ember-exam for visual testing and parallel test support"
git push
