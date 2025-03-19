#!/bin/bash
set -e

echo "Starting entrypoint script..."

# Falls kein Sails-Projekt existiert, wird ein neues erstellt
if [ ! -f package.json ]; then
  echo "No package.json found – creating a new Sails project..."
  sails new . --no-frontend --force
fi

# Installiere den MySQL-Adapter
echo "Installing sails-mysql..."
npm install sails-mysql --save --save-exact

# Erstelle notwendige Verzeichnisse, falls sie nicht existieren
mkdir -p api/models config config/env api/controllers

# Warten, bis das Volume mit den Controllern verfügbar ist
echo "Waiting for controllers folder..."
while [ ! -d "/usr/src/app/api/controllers" ]; do
    sleep 1
done
echo "Controllers folder is available."

# Falls Controller im Volume vorhanden sind, werden sie kopiert
if [ "$(ls -A /usr/src/app/api/controllers)" ]; then
  echo "Copying controllers from volume..."
  cp -r /usr/src/app/api/controllers/* /usr/src/app/tmp_controllers/
  rm -rf /usr/src/app/api/controllers
  mv /usr/src/app/tmp_controllers /usr/src/app/api/controllers
else
  echo "No controllers found, creating default controllers..."
  mkdir -p /usr/src/app/api/controllers

  # Default Controller
  cat <<EOF > /usr/src/app/api/controllers/DefaultController.js
module.exports = {
  index: function(req, res) {
    return res.json({ message: 'Sails.js is running.' });
  }
};
EOF

  # Standard Controller
  cat <<EOF > /usr/src/app/api/controllers/StandardController.js
module.exports = {
  async create(req, res) {
    try {
      const sql = 'INSERT INTO standard (name, message) VALUES (?, ?)';
      const values = [req.body.name, req.body.message];
      const result = await sails.getDatastore().sendNativeQuery(sql, values);
      return res.json({ id: result.insertId, ...req.body });
    } catch (err) {
      return res.serverError(err);
    }
  },

  async read(req, res) {
    try {
      const sql = 'SELECT * FROM standard';
      const result = await sails.getDatastore().sendNativeQuery(sql);
      return res.json(result.rows);
    } catch (err) {
      return res.serverError(err);
    }
  },

  async readOne(req, res) {
    try {
      const sql = 'SELECT * FROM standard WHERE id = ?';
      const result = await sails.getDatastore().sendNativeQuery(sql, [req.params.id]);

      if (result.rows.length === 0) {
        return res.notFound('Record not found');
      }

      return res.json(result.rows[0]);
    } catch (err) {
      return res.serverError(err);
    }
  },

  async update(req, res) {
    try {
      const sql = 'UPDATE standard SET name = ?, message = ? WHERE id = ?';
      const values = [req.body.name, req.body.message, req.params.id];
      const result = await sails.getDatastore().sendNativeQuery(sql, values);

      if (result.affectedRows === 0) {
        return res.notFound('Record not found');
      }

      return res.json({ id: req.params.id, ...req.body });
    } catch (err) {
      return res.serverError(err);
    }
  },

  async delete(req, res) {
    try {
      const sql = 'DELETE FROM standard WHERE id = ?';
      const result = await sails.getDatastore().sendNativeQuery(sql, [req.params.id]);

      if (result.affectedRows === 0) {
        return res.notFound('Record not found');
      }

      return res.json({ message: 'Record deleted successfully' });
    } catch (err) {
      return res.serverError(err);
    }
  }
};
EOF
fi

# Warten, bis das Volume mit den Routen verfügbar ist
echo "Waiting for routes file..."
while [ ! -f "/usr/src/app/config/routes.js" ]; do
    sleep 1
done
echo "Routes file is available."

# Falls routes.js im Volume vorhanden ist, wird es kopiert
if [ -f "/usr/src/app/config/routes.js" ]; then
  echo "Using provided routes.js file."
else
  echo "Creating default routes configuration..."
  cat <<EOF > /usr/src/app/config/routes.js
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

# Installiere Abhängigkeiten
echo "Installing application dependencies..."
npm install

# Starte Sails.js mit PM2
echo "Starting Sails.js with PM2..."
pm2-runtime start app.js
