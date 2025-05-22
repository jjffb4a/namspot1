#!/bin/bash
# scripts/gen24.sh loverk 24.05.2025
# V24: Send SMS to admin on keyword event (e.g., 'alert')

echo "🔧 V24: Installing simulated SMS service"

mkdir -p app/services
cat > app/services/sms.js <<'EOF'
import Service from '@ember/service';

export default class SmsService extends Service {
  send(to, message) {
    console.log(`📲 Simulated SMS to ${to}: "${message}"`);
    // Hook for real provider (e.g., Twilio)
  }
}
EOF

echo "✅ Created: app/services/sms.js"

# Patch ui-box.js to use sms service
TARGET="app/components/ui-box.js"

if ! grep -q "@service sms" "$TARGET"; then
  sed -i '' '/@tracked query/a\
  @service sms;
' "$TARGET"

  sed -i '' '/@action\n  applyQuery()/,/}/ s/}/  if (this.query.includes("alert")) {\n      this.sms.send("+1234567890", `User searched: ${this.query}`);\n    }\n  }/' "$TARGET"
  echo "✅ Patched: $TARGET (inject + usage)"
else
  echo "ℹ️ SMS already used in $TARGET"
fi
