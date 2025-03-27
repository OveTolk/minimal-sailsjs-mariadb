#!/bin/bash
set -e

echo "Installiere globale Abhängigkeiten..."
npm install -g sails pm2

# Falls noch kein Sails-Projekt existiert, erstelle ein neues (ohne Frontend)
if [ ! -f package.json ]; then
  echo "Kein package.json gefunden – erstelle neues Sails-Projekt..."
  sails new . --no-frontend --force
fi

# Installiere den MySQL-Adapter
echo "Installiere sails-mysql..."
npm install sails-mysql --save --save-exact

# Erstelle notwendige Verzeichnisse
mkdir -p api/controllers api/models config config/env

# Kopiere externe Controller (falls vorhanden)
if [ -d /tmp/controllers ]; then
  echo "Kopiere externe Controller von /tmp/controllers nach api/controllers..."
  cp -R /tmp/controllers/* api/controllers/
fi

# Kopiere externe routes.js (falls vorhanden)
if [ -f /tmp/routes.js ]; then
  echo "Kopiere externe routes.js von /tmp nach config/routes.js..."
  cp /tmp/routes.js config/routes.js
fi

# Kopiere externe routes.js (falls vorhanden)
if [ -f /tmp/security.js ]; then
  echo "Kopiere externe security.js von /tmp nach config/security.js..."
  cp /tmp/security.js config/security.js
fi

# --- Datenbank-Konfiguration für Entwicklung ---
cat <<'EOF' > config/datastores.js
module.exports.datastores = {
  default: {
    adapter: 'sails-mysql',
    url: 'mysql://sailsuser:sailspassword@mariadb:3306/sailsdb'
  }
};
EOF

# --- Produktions-Konfiguration ---
cat <<'EOF' > config/env/production.js
module.exports = {
  models: {
    // In Produktion sollte der Migrationsmodus "safe" sein.
    migrate: 'safe'
  },
  datastores: {
    default: {
      adapter: 'sails-mysql',
      url: 'mysql://sailsuser:sailspassword@mariadb:3306/sailsdb'
    }
  }
};
EOF

# --- Session-Konfiguration ---
if [ ! -f config/session.js ]; then
cat <<'EOF' > config/session.js
module.exports.session = {
  secret: true
};
EOF
fi

echo "Installiere App-Abhängigkeiten..."
npm install

echo "Starte Sails.js über PM2..."
pm2-runtime start app.js
