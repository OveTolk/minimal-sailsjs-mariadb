module.exports = {
    friendlyName: 'Check Health',
    description: 'Überprüft HTTP-Zugriff und Datenbankverbindung.',
    inputs: {},
    exits: {
      success: {
        responseType: 'json',
        description: 'HTTP und DB sind in Ordnung.'
      },
      error: {
        responseType: 'serverError',
        description: 'Fehler bei der DB-Verbindung.'
      }
    },
    fn: async function (inputs, exits) {
      try {
        const query = 'SELECT 1 AS result';
        const dbResponse = await sails.getDatastore().sendNativeQuery(query);
        if (
          dbResponse &&
          dbResponse.rows &&
          dbResponse.rows.length > 0 &&
          dbResponse.rows[0].result === 1
        ) {
          return exits.success({
            status: 'OK',
            message: 'HTTP und Datenbankverbindung sind in Ordnung.'
          });
        } else {
          return exits.error({
            status: 'ERROR',
            message: 'Datenbank-Check fehlgeschlagen – unerwartetes Query-Ergebnis.'
          });
        }
      } catch (err) {
        return exits.error({
          status: 'ERROR',
          message: 'Fehler bei der Verbindung zur Datenbank.',
          error: err.message
        });
      }
    }
  };
  