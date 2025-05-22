#!/bin/bash
# 8: Add TypeScript support

pnpm install --save-dev typescript @glint/core @glint/environment-ember-loose

mkdir -p types && cat > types/global.d.ts <<'EOF'
// types/global.d.ts loverk 20.05.2025
declare module '*.hbs' {
  import { TemplateFactory } from 'htmlbars-inline-precompile';
  const tmpl: TemplateFactory;
  export default tmpl;
}
EOF

echo 'typeRoots = ["types"]' >> tsconfig.json

mv app/components/ui-box.js app/components/ui-box.ts

cat > app/components/ui-box.ts <<'EOF'
// app/components/ui-box.ts loverk 20.05.2025
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

type Name = { id: string; text: string };
type Args = {
  names: Name[];
  query: string;
  onSearch: (value: string) => void;
};

export default class UiBoxComponent extends Component<Args> {
  @tracked query = '';
  @tracked appliedQuery = '';

  get filteredNames(): { id: string; html: string }[] {
    const filter = this.appliedQuery.toLowerCase();
    const highlight = this.query.toLowerCase();
    return this.args.names
      .filter((item) => item.text.toLowerCase().includes(filter))
      .map((item) => {
        let text = item.text;
        if (highlight) {
          text = text.replace(
            new RegExp(`(${highlight})`, 'ig'),
            '<mark>$1</mark>'
          );
        }
        return { id: item.id, html: text };
      });
  }

  @action updateQuery(val: string) {
    this.query = val;
  }

  @action applyQuery() {
    this.appliedQuery = this.query;
  }
}
EOF

git add . && git commit -m "v8: Convert ui-box to TypeScript, setup types"

git push