#!/bin/bash
# scripts/gen22.sh loverk 23.05.2025
# gen22.sh — Adds snapshot testing with ember-exam and html-diffing

echo "🔧 Setting up V22: Snapshot testing with Ember Exam"

# Ensure test directories exist
mkdir -p tests/__snapshots__/baseline
mkdir -p tests/__snapshots__/current

# Add a test example if needed
cat > tests/visual/ui-box-snapshot-test.js <<EOF
// tests/visual/ui-box-snapshot-test.js loverk 23.05.2025
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import { hbs } from 'ember-cli-htmlbars';

module('Visual | Snapshot | ui-box', function(hooks) {
  setupRenderingTest(hooks);

  test('renders consistently', async function(assert) {
    this.setProperties({
      names: [
        { id: '1', text: 'Alice in Wonderland' },
        { id: '2', text: 'Bob the Builder' },
        { id: '3', text: 'Clara likes Ember.js' }
      ],
      query: '',
      onSearch: () => {}
    });

    await render(hbs\`
      <UiBox
        @names={{this.names}}
        @query={{this.query}}
        @onSearch={{this.onSearch}}
      />
    \`);

    let html = this.element.innerHTML;
    assert.ok(html.includes('Alice'), 'Sanity: output includes Alice');

    // Save rendered output to file
    let fs = require('fs');
    fs.writeFileSync('tests/__snapshots__/current/ui-box.html', html);
  });
});
EOF

# Explain next steps
echo -e "\n📘 V22 Ready"

echo "👉 Run snapshot tests with:"
echo "   pnpm exec ember exam --split=1 --parallel"

echo "👉 Compare:"
echo "   diff -u tests/__snapshots__/baseline/ui-box.html tests/__snapshots__/current/ui-box.html"

# Ask for chmod
echo -n "❓ Make this script executable with chmod +x? [y/N] "
read confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  chmod +x scripts/gen22.sh
  echo "✅ Script is now executable: scripts/gen22.sh"
else
  echo "ℹ️ Skipped chmod. Run manually if needed."
fi
