module.exports = {
    friendlyName: 'Read Standard Records',
    description: 'Liefert alle Datensätze aus der Tabelle "standard".',
    inputs: {},
    exits: {
      success: {
        responseType: 'json',
        description: 'Datensätze erfolgreich geladen.'
      },
      error: {
        responseType: 'serverError',
        description: 'Datenbankfehler.'
      }
    },
    fn: async function (inputs, exits) {
      try {
        const sql = 'SELECT * FROM standard';
        const result = await sails.getDatastore().sendNativeQuery(sql);
        return exits.success(result.rows);
      } catch (err) {
        return exits.error(err);
      }
    }
  };
  