#!/bin/bash
# scripts/gen19.sh loverk 24.05.2025

# V19: Add persistent search via localStorage
# Adds logic to save/reload the query string from localStorage in ui-box

echo "🔧 Patching app/components/ui-box.js for localStorage persistence"

FILE="app/components/ui-box.js"

if grep -q "localStorage" "$FILE"; then
  echo "⚠️ Already patched."
else
  sed -i '' '/export default class UiBoxComponent extends Component {/a\
  \ \ constructor(owner, args) {\n\ \ \ \ super(owner, args);\n\ \ \ \ const saved = localStorage.getItem("query");\n\ \ \ \ if (saved) this.query = saved;\n\ \ }
  ' "$FILE"

  sed -i '' '/@action\s*updateQuery/ a\
\ \ \ \ localStorage.setItem("query", val);
  ' "$FILE"

  echo "✅ Patched $FILE"
fi

echo "🔧 Patch complete for V19 (persistent search query)"
