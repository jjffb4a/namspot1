mkdir -p .github/workflows && cat > .github/workflows/ci.yml <<'EOF'
# .github/workflows/ci.yml  loverk 20.05.2025
name: 🚀 CI - Namspot1

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: 20

      - run: pnpm install
      - run: pnpm exec ember test --test-port=7357 --path
EOF

git add .github/workflows/ci.yml
git commit -m "v11: Add GitHub Actions CI"
git push
