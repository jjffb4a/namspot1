# v18-theme-toggle.sh
mkdir -p app/components && cat > app/components/theme-toggle.js <<'EOF'
// app/components/theme-toggle.js  loverk 20.05.2025
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

export default class ThemeToggleComponent extends Component {
  @tracked isDark = false;

  @action toggleTheme() {
    this.isDark = !this.isDark;
    document.documentElement.classList.toggle('dark', this.isDark);
    localStorage.setItem('theme', this.isDark ? 'dark' : 'light');
  }

  constructor() {
    super(...arguments);
    let saved = localStorage.getItem('theme');
    if (saved === 'dark') {
      this.isDark = true;
      document.documentElement.classList.add('dark');
    }
  }
}
EOF

mkdir -p app/components && cat > app/components/theme-toggle.hbs <<'EOF'
<!-- app/components/theme-toggle.hbs loverk 20.05.2025 -->
<button
  type="button"
  class="px-3 py-1 text-sm rounded bg-gray-200 dark:bg-gray-700 dark:text-white"
  {{on "click" this.toggleTheme}}
>
  {{if this.isDark "🌙 Dark Mode" "☀️ Light Mode"}}
</button>
EOF

# Inject <ThemeToggle /> in app/templates/application.hbs
sed -i '' '/<UiBox/ i\
  <ThemeToggle />
' app/templates/application.hbs

# Ensure Tailwind dark mode is enabled
sed -i '' 's/darkMode: false/darkMode: "class"/' tailwind.config.js

# Commit and push
git add . &&
git commit -m "v18: Theme toggle with dark/light mode support" &&
git push
