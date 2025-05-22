/* mirage/config.js — loverk 20.05.2025 */
export default function () {
  this.namespace = '/api';

  this.get('/names', () => {
    return [
      { id: '1', text: 'Alice in Wonderland' },
      { id: '2', text: 'Bob the Builder' },
      { id: '3', text: 'Clara from Emberland' },
      { id: '4', text: 'Dora the Explorer' },
    ];
  });
}
