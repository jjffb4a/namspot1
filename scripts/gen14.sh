# scripts/setup-ci-v14.sh  loverk 21.05.2025

# Set up GitHub Actions for Ember CI/CD
mkdir -p .github/workflows && cat > .github/workflows/ci.yml <<'EOF'
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [20.x]

    steps:
    - uses: actions/checkout@v4
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'pnpm'

    - name: Install pnpm
      run: npm install -g pnpm

    - name: Install dependencies
      run: pnpm install

    - name: Run tests
      run: pnpm exec ember test
EOF

# Add notes file
mkdir -p docs && cat > docs/notes_v14_ci.md <<'EOF'
# docs/notes_v14_ci.md  loverk 21.05.2025

## CI/CD Pipeline with GitHub Actions

This version introduces a GitHub Actions workflow (`.github/workflows/ci.yml`) that:

- Triggers on pushes and pull requests to `main`
- Uses Node.js 20.x with pnpm
- Installs all dependencies
- Runs the full test suite with `ember test`

This ensures automated testing for every change on GitHub.
EOF

# Commit and push
chmod +x .github/workflows/ci.yml
chmod +x scripts/setup-ci-v14.sh
git add .
git commit -m "v14: GitHub Actions CI pipeline"
git push

echo "✅ v14 setup complete: CI added via GitHub Actions."
