/* tests/integration/components/ui-box-mirage-test.js — loverk 20.05.2025 */
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, waitFor } from '@ember/test-helpers';
import { hbs } from 'ember-cli-htmlbars';

module('Integration | Component | ui-box | Mirage', function (hooks) {
  setupRenderingTest(hooks);

  test('renders Mirage-loaded names', async function (assert) {
    await render(hbs`<UiBox />`);
    await waitFor('ul li');
    assert.dom('ul li').exists({ count: 4 }, '4 items from Mirage shown');
  });
});
