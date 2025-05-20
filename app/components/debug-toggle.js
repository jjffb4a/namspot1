// app/components/debug-toggle.js loverk 20.05.2025
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

export default class DebugToggleComponent extends Component {
  @tracked enabled = false;

  get statusText() {
    return this.enabled ? 'Debug mode ON' : 'Debug mode OFF';
  }

  @action toggle(e) {
    this.enabled = e.target.value === 'true';
    console.log(`[debug-toggle] Toggled: ${this.enabled}`);
  }
}
