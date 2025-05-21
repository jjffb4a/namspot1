#!/bin/bash
# scripts/setup-dev-tools-v13.sh — loverk 21.05.2025
# Sets up Prettier, ESLint, and Ember-aware config for autoformat + test + commit

# Ensure script runs from root
cd "$(git rev-parse --show-toplevel)" || exit 1

# Install tools
pnpm add -D prettier eslint eslint-plugin-ember eslint-config-prettier

# Create Prettier config
mkdir -p . && cat > .prettierrc <<'EOF'
{
  "singleQuote": true,
  "semi": true,
  "printWidth": 100,
  "tabWidth": 2,
  "trailingComma": "none"
}
EOF

# Create ESLint config
mkdir -p . && cat > eslint.config.mjs <<'EOF'
import eslintPluginEmber from 'eslint-plugin-ember';

export default [
  {
    files: ['**/*.js'],
    languageOptions: {
      sourceType: 'module',
      ecmaVersion: 2020
    },
    plugins: {
      ember: eslintPluginEmber
    },
    rules: {
      ...eslintPluginEmber.configs.recommended.rules
    }
  }
];
EOF

# Make sure watcher script is executable
chmod +x scripts/dev-watch.sh

# Summary
echo "\n✅ Prettier and ESLint configured. Run \"scripts/dev-watch.sh\" to start auto pipeline."
