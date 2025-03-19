#!/bin/bash
# mysql-init/init.sql
-- init.sql Beispielinhalt für Standarddatenbank --
CREATE TABLE IF NOT EXISTS standard (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
