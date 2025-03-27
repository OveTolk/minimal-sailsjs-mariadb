module.exports = {
    friendlyName: 'Create Standard Record',
    description: 'Erstellt einen neuen Datensatz in der Tabelle "standard".',
    inputs: {
      name: {
        type: 'string',
        required: true,
        description: 'Name für den Datensatz'
      },
      message: {
        type: 'string',
        required: false,
        description: 'Nachricht für den Datensatz'
      }
    },
    exits: {
      success: {
        responseType: 'json',
        description: 'Datensatz erfolgreich erstellt.'
      },
      badRequest: {
        responseType: 'badRequest',
        description: 'Erforderliche Parameter fehlen.'
      },
      error: {
        responseType: 'serverError',
        description: 'Datenbankfehler.'
      }
    },
    fn: async function (inputs, exits) {
      try {
        const sql = 'INSERT INTO standard (name, message) VALUES ($1, $2)';
        const result = await sails.getDatastore().sendNativeQuery(sql, [inputs.name, inputs.message]);
        return exits.success({ id: result.insertId, name: inputs.name, message: inputs.message });
      } catch (err) {
        return exits.error(err);
      }
    }
  };
  