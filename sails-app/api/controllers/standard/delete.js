module.exports = {
    friendlyName: 'Delete Standard Record',
    description: 'Löscht einen vorhandenen Datensatz aus der Tabelle "standard".',
    inputs: {
      id: {
        type: 'number',
        required: true,
        description: 'ID des zu löschenden Datensatzes'
      }
    },
    exits: {
      success: {
        responseType: 'json',
        description: 'Datensatz erfolgreich gelöscht.'
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
        const sql = 'DELETE FROM standard WHERE id = $1';
        const result = await sails.getDatastore().sendNativeQuery(sql, [inputs.id]);
        if (result.affectedRows === 0) {
          return exits.notFound('Datensatz nicht gefunden');
        }
        return exits.success({ message: 'Datensatz erfolgreich gelöscht' });
      } catch (err) {
        return exits.error(err);
      }
    }
  };
  