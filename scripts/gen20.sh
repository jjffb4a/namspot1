#!/bin/bash
# scripts/gen20.sh loverk 24.05.2025

# V20: Add basic performance tooling and Lighthouse audit script

echo "🛠️ Adding performance config and audit tools..."

CONFIG_FILE="ember-cli-build.js"
LIGHTHOUSE_SCRIPT="scripts/run-lighthouse-audit.sh"

# Step 1: Enable fingerprinting (helps with cache busting and performance)
if ! grep -q "fingerprint" "$CONFIG_FILE"; then
  echo "🔧 Updating $CONFIG_FILE with fingerprinting..."
  sed -i '' '/return app.toTree()/i\
  \ \ app.options = app.options || {};\n\ \ app.options.fingerprint = {\n\ \ \ \ extensions: ["js", "css", "map"],\n\ \ \ \ generateAssetMap: true,\n\ \ \ \ prepend: "/" // Adjust if needed\n\ \ };
  ' "$CONFIG_FILE"
else
  echo "✅ Fingerprinting already configured."
fi

# Step 2: Create Lighthouse audit script
mkdir -p scripts && cat > "$LIGHTHOUSE_SCRIPT" <<'EOF'
#!/bin/bash
# scripts/run-lighthouse-audit.sh loverk 24.05.2025

echo "🚀 Running Lighthouse performance audit on http://localhost:4200 ..."
echo "ℹ️ Make sure your Ember app is running."

npx --yes lighthouse http://localhost:4200 \
  --output html \
  --output-path ./lighthouse-report.html \
  --quiet

echo "✅ Audit complete. Report saved as lighthouse-report.html"
open lighthouse-report.html || xdg-open lighthouse-report.html
EOF

# Ask to make the audit script executable
echo -n "❓ Make Lighthouse script executable with chmod +x? [y/N] "
read confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  chmod +x "$LIGHTHOUSE_SCRIPT"
  echo "✅ Script is now executable: $LIGHTHOUSE_SCRIPT"
else
  echo "ℹ️ Skipped chmod. Run manually if needed."
fi

echo "✅ V20 complete: Performance fingerprinting & Lighthouse audit tool added."
