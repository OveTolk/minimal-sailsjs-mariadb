#!/bin/bash
set -e

echo "Installiere globale Abhängigkeiten (sails, pm2)..."
npm install -g sails pm2

# Falls noch kein Sails-Projekt existiert, erstelle ein neues (ohne Frontend, da wir nur die API nutzen)
if [ ! -f package.json ]; then
  echo "Kein package.json gefunden – erstelle neues Sails-Projekt..."
  sails new . --no-frontend --force
fi

# Erstelle bzw. überschreibe unsere Custom-Dateien in den richtigen Verzeichnissen

# Stelle sicher, dass die Verzeichnisse existieren
mkdir -p api/controllers api/models config

# Standard Model
if [ ! -f api/models/Standard.js ]; then
cat <<'EOF' > api/models/Standard.js
/**
 * Standard.js
 *
 * @description :: Modell für die Standarddatenbank.
 */
module.exports = {
  attributes: {
    name: {
      type: 'string',
      required: true
    },
    message: {
      type: 'string'
    }
    // createdAt und updatedAt werden automatisch von Sails verwaltet.
  }
};
EOF
fi

# Standard Controller für CRUD
if [ ! -f api/controllers/StandardController.js ]; then
cat <<'EOF' > api/controllers/StandardController.js
/**
 * StandardController.js
 *
 * @description :: Controller für CRUD Operationen auf der Standarddatenbank.
 */
module.exports = {

  // CREATE: Neuen Datensatz anlegen
  create: async function(req, res) {
    try {
      const data = await Standard.create(req.body).fetch();
      return res.json(data);
    } catch (err) {
      return res.serverError(err);
    }
  },

  // READ: Alle Datensätze abrufen
  find: async function(req, res) {
    try {
      const data = await Standard.find();
      return res.json(data);
    } catch (err) {
      return res.serverError(err);
    }
  },

  // READ: Einen Datensatz anhand der ID abrufen
  findOne: async function(req, res) {
    try {
      const data = await Standard.findOne({ id: req.params.id });
      if (!data) { return res.notFound('Datensatz nicht gefunden'); }
      return res.json(data);
    } catch (err) {
      return res.serverError(err);
    }
  },

  // UPDATE: Einen Datensatz aktualisieren
  update: async function(req, res) {
    try {
      const data = await Standard.update({ id: req.params.id }).set(req.body).fetch();
      if (!data.length) { return res.notFound('Datensatz nicht gefunden'); }
      return res.json(data[0]);
    } catch (err) {
      return res.serverError(err);
    }
  },

  // DELETE: Einen Datensatz löschen
  destroy: async function(req, res) {
    try {
      const data = await Standard.destroy({ id: req.params.id }).fetch();
      if (!data.length) { return res.notFound('Datensatz nicht gefunden'); }
      return res.json(data[0]);
    } catch (err) {
      return res.serverError(err);
    }
  }
};
EOF
fi

# Routen-Konfiguration
cat <<'EOF' > config/routes.js
module.exports.routes = {
  'GET /': 'DefaultController.index',
  'POST /standard': 'StandardController.create',
  'GET /standard': 'StandardController.find',
  'GET /standard/:id': 'StandardController.findOne',
  'PUT /standard/:id': 'StandardController.update',
  'DELETE /standard/:id': 'StandardController.destroy'
};
EOF

echo "Abhängigkeiten werden installiert..."
npm install

echo "Starte Sails.js über PM2..."
pm2-runtime start app.js
