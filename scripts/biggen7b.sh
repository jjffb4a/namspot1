#!/bin/bash

# 7b: Add Mirage scenarios: empty dataset and delayed response

mkdir -p mirage/scenarios && cat > mirage/scenarios/empty.js <<'EOF'
// mirage/scenarios/empty.js loverk 20.05.2025
export default function () {
  this.namespace = '/api';
  this.get('/names', () => []);
}
EOF

cat > mirage/scenarios/delayed.js <<'EOF'
// mirage/scenarios/delayed.js loverk 20.05.2025
export default function () {
  this.namespace = '/api';
  this.timing = 2000; // simulate delay
  this.get('/names', (schema) => schema.db.names);
}
EOF

git add . && git commit -m "v7b: Add Mirage scenarios: empty and delayed"

git push