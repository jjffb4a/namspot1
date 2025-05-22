#!/bin/bash

echo "🔧 Applying V16: Accessibility & ARIA Enhancements..."

TARGET="app/components/ui-box.hbs"

# Backup first
cp "$TARGET" "$TARGET.bak.v16"

cat > "$TARGET" <<'EOF'
<!-- app/components/ui-box.hbs — V16 Accessibility Patch -->
<section class="box" role="region" aria-label="Name spotter component">
  <label for="name-search">Search:</label>
  <input
    id="name-search"
    type="text"
    value={{this.query}}
    placeholder="Try Alice, Bob, etc."
    aria-label="Search names"
    {{on-input-value this.updateQuery}} 
    {{on-key-trigger-query this.applyQuery}}
  />
  <ul role="list" aria-live="polite">
    {{#each this.filteredNames as |item|}}
      <li role="listitem">{{{item.html}}}</li>
    {{/each}}
  </ul>
</section>
EOF

echo "✅ V16 patch applied: Accessibility improved in ${TARGET}"

# Commit
git add "$TARGET"
git commit -m "V16: Add ARIA attributes and improve accessibility"
git push
