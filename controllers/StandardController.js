/**
 * StandardController.js
 *
 * @description :: Controller für CRUD-Operationen auf der Standarddatenbank ohne Modell.
 */

module.exports = {
  // CREATE: Neuen Datensatz anlegen
  async create(req, res) {
    try {
      const { name, message } = req.body; // Variablen aus dem Request-Body
      console.log(name, message);
      if (!name) {
        return res.badRequest('Fehlender Parameter: name ist erforderlich.');
      }

      const sql = `INSERT INTO standard (name, message) VALUES ($1, $2)`;
      const result = await sails.getDatastore().sendNativeQuery(sql, [name, message]);

      return res.json({ id: result.insertId, name, message });
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

  // READ: Einen einzelnen Datensatz anhand des Query-Parameters abrufen
  async readOne(req, res) {
    try {
      const { id } = req.query; // ID kommt aus dem Query-Parameter
      if (!id) {
        return res.badRequest('Fehlender Parameter: id ist erforderlich.');
      }

      const sql = `SELECT * FROM standard WHERE id = $1`;
      const result = await sails.getDatastore().sendNativeQuery(sql, [id]);

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
      const { id, name, message } = req.body; // Variablen aus dem Body
      if (!id) {
        return res.badRequest('Fehlender Parameter: id ist erforderlich.');
      }

      const sql = `UPDATE standard SET name = $1, message = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $3`;
      const result = await sails.getDatastore().sendNativeQuery(sql, [name || null, message || null, id]);

      if (result.affectedRows === 0) {
        return res.notFound('Datensatz nicht gefunden');
      }

      return res.json({ id, name, message });
    } catch (err) {
      return res.serverError(err);
    }
  },

  // DELETE: Einen Datensatz löschen anhand des Query-Parameters
  async delete(req, res) {
    try {
      const { id } = req.query; // ID kommt aus dem Query-Parameter
      if (!id) {
        return res.badRequest('Fehlender Parameter: id ist erforderlich.');
      }

      const sql = `DELETE FROM standard WHERE id = $1`;
      const result = await sails.getDatastore().sendNativeQuery(sql, [id]);

      if (result.affectedRows === 0) {
        return res.notFound('Datensatz nicht gefunden');
      }

      return res.json({ message: 'Datensatz erfolgreich gelöscht' });
    } catch (err) {
      return res.serverError(err);
    }
  }
};
