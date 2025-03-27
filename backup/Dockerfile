FROM mariadb:latest

RUN apt-get update && apt-get install -y cron

# Copy backup script
COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

# Add cron job (alle 12h – anpassbar)
RUN echo "0 */12 * * * /backup.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/db-backup \
 && chmod 0644 /etc/cron.d/db-backup \
 && crontab /etc/cron.d/db-backup

CMD ["cron", "-f"]
