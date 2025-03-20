# Erstellung eines Controllers in Sails.js

Diese Dokumentation beschreibt, wie ein Controller in Sails.js aufgebaut wird, um CRUD-Operationen (Create, Read, Update, Delete) mit einer Datenbank durchzuführen. 

## Aufbau eines Controllers

Ein Controller in Sails.js ist eine JavaScript-Datei, die Methoden für verschiedene API-Endpunkte enthält. Jede Methode verarbeitet Anfragen und sendet Antworten basierend auf den HTTP-Methoden.

Ein typischer Controller kann wie folgt aussehen:

```javascript
/**
 * StandardController.js
 *
 * @description :: Controller für CRUD-Operationen ohne Modell.
 */

module.exports = {
  async create(req, res) {
    try {
      const { name, message } = req.body;
      if (!name) {
        return res.badRequest('Fehlender Parameter: name ist erforderlich.');
      }
      const sql = `INSERT INTO standard (name, message) VALUES ($1, $2)`;
      const result = await sails.getDatastore().sendNativeQuery(sql, [name, message]);
      return res.json({ id: result.insertId, name, message });
    } catch (err) {
      return res.serverError(err);
    }
  }
};
```

## Erklärung der wichtigsten Konzepte

### 1. **Anfragen verarbeiten**

- `req.body`: Enthält die JSON-Daten, die im Request-Body gesendet wurden.
- `req.query`: Enthält Parameter, die über die URL übergeben werden (z. B. `?id=1`).
- `req.params`: Enthält Parameter, die als Teil der Route definiert wurden (z. B. `/user/:id`).

### 2. **Antworten senden**

- `res.json(data)`: Sendet eine JSON-Antwort zurück.
- `res.badRequest(message)`: Sendet eine 400-Fehlermeldung bei fehlenden oder falschen Parametern.
- `res.notFound(message)`: Sendet eine 404-Antwort, wenn ein Datensatz nicht existiert.
- `res.serverError(error)`: Sendet eine 500-Fehlermeldung bei unerwarteten Fehlern.

### 3. **Datenbankabfragen mit Native Query**

Sails.js ermöglicht direkte SQL-Abfragen mit `sendNativeQuery()`. Beispiel:

```javascript
const sql = `SELECT * FROM standard WHERE id = $1`;
const result = await sails.getDatastore().sendNativeQuery(sql, [id]);
```

Die Parameter (`$1, $2, ...`) schützen vor SQL-Injections.

## CRUD-Methoden

### **1. Create (POST /standard/create)**
- Fügt einen neuen Datensatz hinzu.
- Erwartet `name` und `message` im `req.body`.

### **2. Read (GET /standard/read)**
- Gibt alle Datensätze zurück.

### **3. Read One (GET /standard/readOne?id=1)**
- Gibt einen spezifischen Datensatz anhand der ID zurück.

### **4. Update (PUT /standard/update)**
- Aktualisiert einen Datensatz anhand der ID.
- Erwartet `id`, `name` und/oder `message` im `req.body`.

### **5. Delete (DELETE /standard/delete?id=1)**
- Löscht einen Datensatz anhand der ID.

## Fehlercodes und deren Bedeutung

- **400 Bad Request**: Fehlende oder ungültige Parameter.
- **404 Not Found**: Der angeforderte Datensatz existiert nicht.
- **500 Internal Server Error**: Ein unerwarteter Fehler ist aufgetreten.

## Fazit

Dieser Controller zeigt, wie CRUD-Operationen mit Sails.js implementiert werden. Durch den Einsatz von `req.body`, `req.query` und `sendNativeQuery()` lassen sich performante und sichere Datenbankabfragen realisieren.

Weitere Optimierungen könnten eine Fehler-Logging-Mechanik oder die Nutzung von Sails.js Modellen umfassen.
