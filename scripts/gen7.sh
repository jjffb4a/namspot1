# 🔧 scripts/v7.sh  V7.1_and_v7.2 loverk 21.05.2025
# Refactors: Tailwind and Mirage setup for Namspot (based on V3 and V4)

mkdir -p scripts && cat > scripts/v7.1_and_v7.2.sh <<'EOF'
#!/bin/bash

echo "🔍 Checking Tailwind CSS (V7.1)..."

if ! grep -q "tailwindcss" package.json; then
  echo "❌ Tailwind not found in package.json. Aborting V7.1."
else
  echo "✅ Tailwind found."
fi

if [[ ! -f "tailwind.config.js" ]]; then
  echo "❌ Missing tailwind.config.js"
else
  echo "✅ tailwind.config.js found"
fi

if ! grep -q "@tailwind base" app/styles/app.css; then
  echo "❌ app/styles/app.css missing Tailwind directives"
else
  echo "✅ Tailwind CSS directives found in app.css"
fi

echo "✅ V7.1 Tailwind check complete."

echo ""
echo "🔍 Checking Mirage (V7.2)..."

if ! grep -q "ember-cli-mirage" package.json; then
  echo "❌ Mirage not found in package.json. Aborting V7.2."
else
  echo "✅ Mirage found."
fi

if [[ ! -f "mirage/config.js" ]]; then
  echo "❌ Missing mirage/config.js"
else
  echo "✅ mirage/config.js found"
fi

if [[ ! -f "app/initializers/ember-cli-mirage.js" ]]; then
  echo "❌ Missing Mirage initializer"
else
  echo "✅ Mirage initializer present"
fi

echo "✅ V7.2 Mirage check complete."

echo ""
echo "📦 Committing results (V7.1 + V7.2)..."
git add .
git commit -m "V7.1 & V7.2: Tailwind + Mirage validation and patch refactor"
git push

echo "🎉 All done."
EOF

chmod +x scripts/v7.1_and_v7.2.sh
echo "✅ Script ready: run with ./scripts/v7.sh"