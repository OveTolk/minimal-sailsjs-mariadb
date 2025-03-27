module.exports.security = {
    cors: {
      // Liest die Umgebungsvariable aus und wandelt sie in einen Boolean um
      allRoutes: process.env.CORS_ALL_ROUTES === 'true',
      // Falls eine Komma-separierte Liste definiert ist, wird diese in ein Array umgewandelt; sonst wird '*' verwendet
      allowOrigins: process.env.CORS_ALLOW_ORIGINS ? process.env.CORS_ALLOW_ORIGINS.split(',') : '*',
      // Weitere Optionen können hier ergänzt werden, z.B. allowCredentials, falls benötigt
    },
    // Aktiviert oder deaktiviert den CSRF-Schutz basierend auf der Umgebungsvariable
    csrf: process.env.CSRF_ENABLED === 'true'
  };
  