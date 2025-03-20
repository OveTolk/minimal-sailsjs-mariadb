# Sails.js Simple CRUD API

Eine minimal gehaltene CRUD API, die mit Sails.js entwickelt wurde. Sie unterstützt MariaDB via SQL-Konfigurationsdateien, beinhaltet eine vorkonfigurierte Standardumgebung und ist sofort über Docker Compose einsatzbereit.

## Features

### Einfache API
- CRUD-Operationen (Create, Read, Update, Delete) für einen schnellen Einstieg in den API-Betrieb.

### Datenbankkonfiguration per SQL
- Die benötigten SQL-Dateien zur Einrichtung der Datenbankkonfigurationen befinden sich im Verzeichnis `./mysql-init`.

### Standardkonfiguration bereits vorhanden
- Vorinstallierte Konfigurationen für Sails.js und die Datenbank (MariaDB) sorgen für einen reibungslosen Start.

### Docker Compose
- Eine vollständig konfigurierte `docker-compose.yml` ermöglicht das sofortige Starten aller notwendigen Dienste.

### Sofort verfügbar
- Schnell startklar – einfach Container hochfahren und direkt loslegen.

## Voraussetzungen

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Installation

### Repository klonen:

```bash
git clone <repository-url>
cd <repository-directory>
```

### Container starten:

```bash
docker-compose up -d
```

### API aufrufen:

Die API ist nun unter [http://localhost:1337](http://localhost:1337) erreichbar.

## Datenbankkonfiguration

- SQL-Dateien im Verzeichnis `./mysql-init` konfigurieren die Datenbank bei Container-Start.
- Die Standardkonfiguration für MariaDB und Sails.js ist bereits integriert.

## API Dokumentation

### Endpunkt: Standard

**URL:**  
`http://localhost:1337/standard`

**Verfügbare Methoden:**

- `GET`: Alle Datensätze abrufen
- `POST`: Einen neuen Datensatz erstellen
- `PUT`: Einen bestehenden Datensatz aktualisieren
- `DELETE`: Einen Datensatz löschen

**Hinweis:** Für `DELETE` und `readOne` wird die ID als Query-Parameter übergeben, z. B.:  
`/standard?id=1`

### Beispielanfrage (POST)

Verwenden Sie Postman oder cURL, um einen neuen Datensatz anzulegen:

#### JSON Request Body

```json
{
  "name": "Test User",
  "message": "Hello from Postman"
}
```

#### cURL Beispiel:

```bash
curl -X POST http://localhost:1337/standard \
  -H "Content-Type: application/json" \
  -d '{"name": "Test User", "message": "Hello from Postman"}'
```

Weitere Beispiele zu den API-Endpunkten finden Sie in der Postman Collection.

## Postman Collection

Eine Postman Collection zum Testen der API ist als `postman_collection.json` im Repository verfügbar.  
Importieren Sie die Collection in Postman oder laden Sie sie direkt hier herunter.

## Lizenz

Dieses Projekt ist unter der **MIT Lizenz** lizenziert.

## Kontakt und Mitwirkung

Haben Sie Fragen oder Verbesserungsvorschläge?  
Eröffnen Sie bitte ein **Issue** oder senden Sie einen **Pull Request** – jede Rückmeldung ist willkommen!