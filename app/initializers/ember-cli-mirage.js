/* app/initializers/ember-cli-mirage.js — loverk 20.05.2025 */
import config from 'namspot1/config/environment';
import startMirage from 'ember-cli-mirage/start';

export function initialize() {
  if (config.environment === 'development' || config.environment === 'test') {
    startMirage();
  }
}

export default {
  initialize,
};
