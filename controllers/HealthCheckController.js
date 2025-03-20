/**
 * HealthCheckController.js
 *
 * @description :: Controller für einen Health Check, der den HTTP-Zugriff und die Verbindung zur Datenbank überprüft.
 */

module.exports = {
    async check(req, res) {
      try {
        // Führe einen einfachen Query aus, um die Datenbankverbindung zu prüfen
        const query = 'SELECT 1 AS result';
        const dbResponse = await sails.getDatastore().sendNativeQuery(query);
  
        if (
          dbResponse &&
          dbResponse.rows &&
          dbResponse.rows.length > 0 &&
          dbResponse.rows[0].result === 1
        ) {
          return res.json({
            status: 'OK',
            message: 'HTTP und Datenbankverbindung sind in Ordnung.'
          });
        } else {
          return res.status(500).json({
            status: 'ERROR',
            message: 'Datenbank-Check fehlgeschlagen – unerwartetes Query-Ergebnis.'
          });
        }
      } catch (err) {
        return res.status(500).json({
          status: 'ERROR',
          message: 'Fehler bei der Verbindung zur Datenbank.',
          error: err.message
        });
      }
    }
};
  