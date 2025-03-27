module.exports = {
    friendlyName: 'Read One Standard Record',
    description: 'Liefert einen einzelnen Datensatz anhand der ID aus der Tabelle "standard".',
    inputs: {
      id: {
        type: 'number',
        required: true,
        description: 'ID des abzurufenden Datensatzes'
      }
    },
    exits: {
      success: {
        responseType: 'json',
        description: 'Datensatz erfolgreich geladen.'
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
        const sql = 'SELECT * FROM standard WHERE id = $1';
        const result = await sails.getDatastore().sendNativeQuery(sql, [inputs.id]);
        if (result.rows.length === 0) {
          return exits.notFound('Datensatz nicht gefunden');
        }
        return exits.success(result.rows[0]);
      } catch (err) {
        return exits.error(err);
      }
    }
  };
  