#!/bin/bash

# Erstelle benötigte Verzeichnisse und Dateien, falls sie nicht existieren
mkdir -p mysql-init
mkdir -p sails-app/api/controllers
mkdir -p sails-app/api/models
mkdir -p sails-app/config

# Erstelle die SQL-Datei für die Standarddatenbank
cat <<EOL > mysql-init/init.sql
-- init.sql Beispielinhalt für Standarddatenbank --
CREATE TABLE IF NOT EXISTS standard (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
EOL

# Erstelle das Standard Sails Model falls nicht vorhanden
if [ ! -f sails-app/api/models/Standard.js ]; then
cat <<EOL > sails-app/api/models/Standard.js
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
EOL
fi

# Erstelle den Standard Controller für CRUD Befehle falls nicht vorhanden
if [ ! -f sails-app/api/controllers/StandardController.js ]; then
cat <<EOL > sails-app/api/controllers/StandardController.js
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
EOL
fi

# Erstelle oder aktualisiere die Routen
cat <<EOL > sails-app/config/routes.js
module.exports.routes = {
  'GET /': 'DefaultController.index',
  'POST /standard': 'StandardController.create',
  'GET /standard': 'StandardController.find',
  'GET /standard/:id': 'StandardController.findOne',
  'PUT /standard/:id': 'StandardController.update',
  'DELETE /standard/:id': 'StandardController.destroy'
};
EOL

# Falls eine README.md nicht existiert, lege eine an
if [ ! -f sails-app/README.md ]; then
    echo "# Sails.js Projekt" > sails-app/README.md
    echo "Dieses Projekt verwendet Docker mit Sails.js und MariaDB." >> sails-app/README.md
fi

echo "Alle benötigten Dateien und Ordner wurden erstellt und angepasst!"
