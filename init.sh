#!/bin/bash

# Erstelle benötigte Verzeichnisse
mkdir -p sails-app/api/controllers
mkdir -p sails-app/api/models
mkdir -p sails-app/config

# Standard Controller für CRUD
if [ ! -f sails-app/api/controllers/StandardController.js ]; then
cat <<EOL > sails-app/api/controllers/StandardController.js
/**
 * StandardController.js
 *
 * @description :: Controller für CRUD Operationen auf der Standarddatenbank.
 */
module.exports = {

  // CREATE: Neuen Datensatz anlegen
  async create(req, res) {
    try {
      const data = await create(req.body).fetch();
      return res.json(data);
    } catch (err) {
      return res.serverError(err);
    }
  },

  // READ: Alle Datensätze abrufen
  async find(req, res) {
    try {
      const data = await find();
      return res.json(data);
    } catch (err) {
      return res.serverError(err);
    }
  },

  // READ: Einen Datensatz anhand der ID abrufen
  async findOne(req, res) {
    try {
      const data = await findOne({ id: req.params.id });
      if (!data) { return res.notFound('Datensatz nicht gefunden'); }
      return res.json(data);
    } catch (err) {
      return res.serverError(err);
    }
  },

  // UPDATE: Einen Datensatz aktualisieren
  async update(req, res) {
    try {
      const data = await update({ id: req.params.id }).set(req.body).fetch();
      if (!data.length) { return res.notFound('Datensatz nicht gefunden'); }
      return res.json(data[0]);
    } catch (err) {
      return res.serverError(err);
    }
  },

  // DELETE: Einen Datensatz löschen
  async delete(req, res) {
    try {
      const data = await destroy({ id: req.params.id }).fetch();
      if (!data.length) { return res.notFound('Datensatz nicht gefunden'); }
      return res.json(data[0]);
    } catch (err) {
      return res.serverError(err);
    }
  }
};
EOL
fi

# Routen-Konfiguration
cat <<EOL > sails-app/config/routes.js
module.exports.routes = {
  'GET /': 'DefaultController.index',
  'POST /standard': 'StandardController.create',
  'GET /standard': 'StandardController.find',
  'GET /standard/:id': 'StandardController.findOne',
  'PUT /standard/:id': 'StandardController.update',
  'DELETE /standard/:id': 'StandardController.delete'
};
EOL

# Routen-Konfiguration
cat <<EOL > sails-app/config/session.js
module.exports.session = {
  secret: true
};
EOL



echo "Alle benötigten Dateien und Ordner wurden erstellt!"
