/* app/services/name-loader.js — loverk 20.05.2025 */
import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class NameLoaderService extends Service {
  @tracked names = [];

  async load() {
    try {
      const res = await fetch('/api/names');
      const json = await res.json();
      this.names = json;
      console.log('[NameLoader] loaded:', this.names);
    } catch (e) {
      console.error('❌ Name loading failed:', e);
    }
  }
}
