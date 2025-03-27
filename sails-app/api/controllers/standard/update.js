module.exports = {
    friendlyName: 'Update Standard Record',
    description: 'Aktualisiert einen vorhandenen Datensatz in der Tabelle "standard".',
    inputs: {
      id: {
        type: 'number',
        required: true,
        description: 'ID des zu aktualisierenden Datensatzes'
      },
      name: {
        type: 'string',
        required: false,
        description: 'Neuer Name für den Datensatz'
      },
      message: {
        type: 'string',
        required: false,
        description: 'Neue Nachricht für den Datensatz'
      }
    },
    exits: {
      success: {
        responseType: 'json',
        description: 'Datensatz erfolgreich aktualisiert.'
      },
      notFound: {
        responseType: 'notFound',
        description: 'Datensatz nicht gefunden.'
      },
      error: {
        responseType: 'serverError',
        description: 'Datenbankfehler.'
      }
    },
    fn: async function (inputs, exits) {
      try {
        const sql = 'UPDATE standard SET name = $1, message = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $3';
        const result = await sails.getDatastore().sendNativeQuery(sql, [inputs.name || null, inputs.message || null, inputs.id]);
        if (result.affectedRows === 0) {
          return exits.notFound('Datensatz nicht gefunden');
        }
        return exits.success({ id: inputs.id, name: inputs.name, message: inputs.message });
      } catch (err) {
        return exits.error(err);
      }
    }
  };
  