#!/bin/bash

# Erstelle benötigte Verzeichnisse und Dateien, falls sie nicht existieren
mkdir -p mysql-init
mkdir -p sails-app/api/controllers
mkdir -p sails-app/config

# Initiale Dateien, falls sie nicht existieren
if [ ! -f mysql-init/init.sql ]; then
    echo "-- init.sql Beispielinhalt --" > mysql-init/init.sql
    echo "CREATE TABLE IF NOT EXISTS example (" >> mysql-init/init.sql
    echo "    id INT AUTO_INCREMENT PRIMARY KEY," >> mysql-init/init.sql
    echo "    name VARCHAR(255) NOT NULL" >> mysql-init/init.sql
    echo ");" >> mysql-init/init.sql
fi

if [ ! -f sails-app/api/controllers/DefaultController.js ]; then
    cat <<EOL > sails-app/api/controllers/DefaultController.js
module.exports = {
  index: function(req, res) {
    const fs = require('fs');
    const readme = fs.readFileSync('README.md', 'utf8');
    return res.send(readme);
  }
};
EOL
fi

if [ ! -f sails-app/config/routes.js ]; then
    cat <<EOL > sails-app/config/routes.js
module.exports.routes = {
  'GET /': 'DefaultController.index'
};
EOL
fi

# Falls eine README.md nicht existiert, lege eine an
if [ ! -f sails-app/README.md ]; then
    echo "# Sails.js Projekt" > sails-app/README.md
    echo "Dieses Projekt verwendet Docker mit Sails.js und MariaDB." >> sails-app/README.md
fi

echo "Alle benötigten Dateien und Ordner wurden erstellt!"
