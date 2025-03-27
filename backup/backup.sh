#!/bin/bash
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
mysqldump -hmariadb -usailsuser -psailspassword sailsdb > /backups/sailsdb_$TIMESTAMP.sql
