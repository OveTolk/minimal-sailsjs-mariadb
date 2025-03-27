module.exports.security = {
  csrf: process.env.CSRF_ENABLED === 'true',
  cors: {
    allRoutes: process.env.CORS_ALL_ROUTES === 'true',
    allowOrigins: process.env.CORS_ALLOW_ORIGINS
      ? process.env.CORS_ALLOW_ORIGINS.split(',')
      : '*',
    allowCredentials: true
  }
};
