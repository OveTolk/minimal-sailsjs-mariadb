module.exports.routes = {
    'GET /health': {
      action: 'healthcheck/check',
      cors: {
        allowOrigins: process.env.CORS_ALLOW_ORIGINS
          ? process.env.CORS_ALLOW_ORIGINS.split(',')
          : '*',
        allowCredentials: false
      }
    },
    'POST /standard': { action: 'standard/create' },
    'GET /standard': { action: 'standard/read' },
    'GET /standard/:id': { action: 'standard/read-one' },
    'PUT /standard/:id': { action: 'standard/update' },
    'DELETE /standard/:id': { action: 'standard/delete' }
  };
  