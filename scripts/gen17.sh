#!/bin/bash

# V17 - Accessibility Improvements (ARIA, Roles, Labels)
echo "\n🔁 Applying V17 accessibility enhancements..."

# 1. Add ARIA attributes to input and list in template
FILE_APP_HBS="app/components/ui-box.hbs"
if grep -q '<input' "$FILE_APP_HBS"; then
  sed -i '' 's/<input/<input aria-label="Name search input" role="searchbox"/' "$FILE_APP_HBS"
  echo "✅ Added aria-label and role to <input>"
fi

if grep -q '<ul' "$FILE_APP_HBS"; then
  sed -i '' 's/<ul/<ul aria-live="polite" role="list"/' "$FILE_APP_HBS"
  echo "✅ Added aria-live and role to <ul>"
fi

# 2. Add roles to <li> items if necessary
if grep -q '{{#each this.filteredNames' "$FILE_APP_HBS"; then
  sed -i '' 's/<li /<li role="listitem" /' "$FILE_APP_HBS"
  echo "✅ Added role to list items"
fi

# 3. Add accessibility helper if needed (optional step)
mkdir -p app/helpers
cat > app/helpers/a11y-label.js <<'EOF'
// app/helpers/a11y-label.js  V17 loverk 20.05.2025
export default function a11yLabel(name) {
  return `${name} list item`;
}
EOF

# 4. Patch style to improve focus visibility
STYLE_FILE="app/styles/app.css"
if ! grep -q ':focus' "$STYLE_FILE"; then
  cat >> "$STYLE_FILE" <<'EOF'
input:focus {
  outline: 2px solid #4b9cd3;
  outline-offset: 2px;
}
li:focus {
  outline: 2px dashed #4b9cd3;
  outline-offset: 2px;
}
EOF
  echo "✅ Enhanced focus outline styles"
fi

# 5. Commit changes

git add .
git commit -m "V17: Accessibility improvements (ARIA, roles, focus outlines)"
git push

# 6. Save developer notes
mkdir -p docs
cat > docs/notes_v17.md <<'EOF'
# docs/notes_v17.md  loverk 20.05.2025

## 🧩 V17 – Accessibility Enhancements

### 🎯 Purpose
Improve the accessibility of the UI by:
- Adding ARIA attributes to key elements
- Enhancing keyboard navigation with focus outlines
- Supporting screen reader roles for better assistive tech integration

### 🛠 Implementation
- `aria-label`, `aria-live`, `role` attributes added in `ui-box.hbs`
- Focus styles applied in `app.css`
- Optional helper `a11y-label.js` created for screen reader labels

### 🧪 How to Test
- Navigate using keyboard (Tab) and observe outlines
- Use a screen reader to test element roles and labels
- Confirm that the app behaves identically in function but is more accessible

EOF

echo "✅ V17 applied successfully."
