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
