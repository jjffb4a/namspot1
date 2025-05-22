#!/bin/bash
# scripts/gen23.sh loverk 23.05.2025
# V23: Admin Area using Mirage + Tailwind, debug-only controls

echo "🔧 Setting up V23: Admin interface with Mirage + Tailwind"

# Create route + template
mkdir -p app/routes app/templates app/components
cat > app/routes/admin.js <<'EOF'
import Route from '@ember/routing/route';

export default class AdminRoute extends Route {
  model() {
    return this.store.findAll('name');
  }
}
EOF

cat > app/templates/admin.hbs <<'EOF'
<h2 class="text-xl font-bold mb-4">Admin Panel</h2>
<AdminTools @names={{this.model}} />
<LinkTo @route="index" class="text-blue-600 underline">← Back to Home</LinkTo>
EOF

# Add AdminTools component (JS + HBS)
mkdir -p app/components
cat > app/components/admin-tools.js <<'EOF'
import Component from '@glimmer/component';
import { action } from '@ember/object';

export default class AdminToolsComponent extends Component {
  @action
  remove(name) {
    name.destroyRecord();
  }

  @action
  reset() {
    this.args.names.forEach((n) => n.destroyRecord());
  }

  @action
  add() {
    let newName = prompt('Enter a new name:');
    if (newName) {
      this.args.names.createRecord({ text: newName }).save();
    }
  }
}
EOF

cat > app/components/admin-tools.hbs <<'EOF'
{{#if (query-param "debug")}}
  <div class="space-y-2 border p-4 rounded shadow">
    <button type="button" class="bg-green-200 px-2 py-1" {{on "click" this.add}}>Add Name</button>
    <button type="button" class="bg-yellow-200 px-2 py-1" {{on "click" this.reset}}>Reset</button>

    <ul>
      {{#each @names as |name|}}
        <li class="flex justify-between items-center">
          <span>{{name.text}}</span>
          <button class="text-red-500 text-sm" {{on "click" (fn this.remove name)}}>Remove</button>
        </li>
      {{/each}}
    </ul>
  </div>
{{else}}
  <p class="text-sm text-gray-500">🔒 Admin mode disabled (add ?debug=true)</p>
{{/if}}
EOF

# Add Mirage support
mkdir -p mirage/models
cat > mirage/models/name.js <<'EOF'
import { Model } from 'miragejs';
export default Model;
EOF

cat > mirage/config.js <<'EOF'
export default function() {
  this.namespace = '/api';

  this.get('/names', (schema) => {
    return schema.names.all();
  });

  this.post('/names', (schema, request) => {
    let attrs = JSON.parse(request.requestBody);
    return schema.names.create(attrs);
  });

  this.del('/names/:id');
}
EOF

echo "✅ V23 complete: Admin area with Mirage & Tailwind is ready"
echo "👉 Visit /admin?debug=true to test UI"

# Ask before making script executable
echo -n "❓ Make this script executable with chmod +x? [y/N] "
read confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  chmod +x scripts/gen23.sh
  echo "✅ Script is now executable: scripts/gen23.sh"
else
  echo "ℹ️ Skipped chmod. Run manually if needed."
fi
