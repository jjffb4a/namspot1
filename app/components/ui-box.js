// FILE: app/components/ui-box.js loverk 20.05.2025
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { service } from "@ember/service";
import { action } from '@ember/object';


export default class UiBoxComponent extends Component {
  @service nameLoader;
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
