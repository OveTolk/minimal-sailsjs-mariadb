#!/bin/bash
set -e

echo "Installiere globale Abhängigkeiten (sails, pm2)..."
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

# --- Standard Controller ---
if [ ! -f api/controllers/StandardController.js ]; then
cat <<'EOF' > api/controllers/StandardController.js
/**
 * StandardController.js
 *
 * @description :: Controller für CRUD-Operationen auf der Standarddatenbank ohne Modell.
 */

module.exports = {
  // CREATE: Neuen Datensatz anlegen
  async create(req, res) {
    try {
      const sql = `INSERT INTO standard SET ?`;
      const values = req.body;

      const result = await sails.getDatastore().sendNativeQuery(sql, [values]);
      return res.json({ id: result.insertId, ...values });
    } catch (err) {
      return res.serverError(err);
    }
  },

  // READ: Alle Datensätze abrufen
  async read(req, res) {
    try {
      const sql = `SELECT * FROM standard`;
      const result = await sails.getDatastore().sendNativeQuery(sql);
      return res.json(result.rows);
    } catch (err) {
      return res.serverError(err);
    }
  },

  // READ: Einen Datensatz anhand der ID abrufen
  async readOne(req, res) {
    try {
      const sql = `SELECT * FROM standard WHERE id = ?`;
      const result = await sails.getDatastore().sendNativeQuery(sql, [req.params.id]);

      if (result.rows.length === 0) {
        return res.notFound('Datensatz nicht gefunden');
      }

      return res.json(result.rows[0]);
    } catch (err) {
      return res.serverError(err);
    }
  },

  // UPDATE: Einen Datensatz aktualisieren
  async update(req, res) {
    try {
      const sql = `UPDATE standard SET ? WHERE id = ?`;
      const values = req.body;
      const result = await sails.getDatastore().sendNativeQuery(sql, [values, req.params.id]);

      if (result.affectedRows === 0) {
        return res.notFound('Datensatz nicht gefunden');
      }

      return res.json({ id: req.params.id, ...values });
    } catch (err) {
      return res.serverError(err);
    }
  },

  // DELETE: Einen Datensatz löschen
  async delete(req, res) {
    try {
      const sql = `DELETE FROM standard WHERE id = ?`;
      const result = await sails.getDatastore().sendNativeQuery(sql, [req.params.id]);

      if (result.affectedRows === 0) {
        return res.notFound('Datensatz nicht gefunden');
      }

      return res.json({ message: 'Datensatz erfolgreich gelöscht' });
    } catch (err) {
      return res.serverError(err);
    }
  }
};
EOF
fi

# --- Default Controller ---
if [ ! -f api/controllers/DefaultController.js ]; then
cat <<'EOF' > api/controllers/DefaultController.js
/**
 * DefaultController.js
 *
 * @description :: Einfache Beispielaktion.
 */
module.exports = {
  index: function(req, res) {
    return res.json({ message: 'Hello, world! Sails.js läuft.' });
  }
};
EOF
fi

# --- Falls keine externe routes.js vorhanden, erstelle Standard-Routen-Konfiguration ---
if [ ! -f config/routes.js ]; then
cat <<'EOF' > config/routes.js
module.exports.routes = {
  'GET /': 'DefaultController.index',
  'POST /standard': 'StandardController.create',
  'GET /standard': 'StandardController.read',
  'GET /standard/:id': 'StandardController.readOne',
  'PUT /standard/:id': 'StandardController.update',
  'DELETE /standard/:id': 'StandardController.delete'
};
EOF
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
