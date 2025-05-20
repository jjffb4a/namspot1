# Create the app
ember new namspot1 --lang en --skip-git --skip-npm --no-welcome

cd namspot1

pnpm install

# COMPONENT JS
mkdir -p app/components && cat > app/components/ui-box.js <<'EOF'
// FILE: app/components/ui-box.js loverk 20.05.2025
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

export default class UiBoxComponent extends Component {
  @tracked query = '';

  get highlightedNames() {
    const query = this.query.toLowerCase();
    return this.args.names.map((item) => {
      let text = item.text;
      if (query && text.toLowerCase().includes(query)) {
        text = text.replace(
          new RegExp(`(${query})`, 'ig'),
          '<mark>$1</mark>'
        );
      }
      return { id: item.id, html: text };
    });
  }

  @action
  updateQuery(event) {
    this.query = event.target.value;
  }
}
EOF

# COMPONENT TEMPLATE
mkdir -p app/components && cat > app/components/ui-box.hbs <<'EOF'
<!-- FILE: app/components/ui-box.hbs loverk 20.05.2025 -->
<div class="box">
  <label>Search:</label>
  <input
    type="text"
    value={{this.query}}
    placeholder="Try Alice, Bob, etc."
    {{on "input" this.updateQuery}}
  />

  <ul>
    {{#each this.highlightedNames as |item|}}
      <li>{{{item.html}}}</li>
    {{/each}}
  </ul>
</div>
EOF

# SIMPLE CSS
mkdir -p app/styles && cat > app/styles/app.css <<'EOF'
/* FILE: app/styles/app.css loverk 20.05.2025 */
body {
  font-family: sans-serif;
  margin: 2rem;
}
input {
  margin: 1rem 0;
  padding: 0.5rem;
}
mark {
  background: yellow;
}
EOF

# APPLICATION TEMPLATE
mkdir -p app/templates && cat > app/templates/application.hbs <<'EOF'
<!-- FILE: app/templates/application.hbs loverk 20.05.2025 -->
<h1>Name Highlighter</h1>

<UiBox
  @names={{array
    (hash id="1" text="Alice went to Berlin")
    (hash id="2" text="Bob and Eva")
    (hash id="3" text="Clara likes Ember.js")
  }}
/>
EOF

# TEST FILE
mkdir -p tests/integration/components && cat > tests/integration/components/ui-box-test.js <<'EOF'
// FILE: tests/integration/components/ui-box-test.js loverk 20.05.2025
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, fillIn } from '@ember/test-helpers';
import { hbs } from 'ember-cli-htmlbars';

module('Integration | Component | ui-box', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders and highlights names', async function (assert) {
    this.set('names', [
      { id: '1', text: 'Alice went to Berlin' },
      { id: '2', text: 'Bob and Eva' },
      { id: '3', text: 'Clara likes Ember.js' }
    ]);

    await render(hbs`<UiBox @names={{this.names}} />`);

    assert.dom('input').exists();
    await fillIn('input', 'alice');
    assert.dom('ul li').exists({ count: 3 });
    assert.dom('ul').includesText('Alice');
    assert.ok(
      this.element.innerHTML.includes('<mark>Alice</mark>'),
      'Highlights Alice'
    );
  });
});
EOF

# Done
echo "✅ Project 'namspot1' scaffolded. Run it with: pnpm exec ember serve"
