module.exports.routes = {
    'GET /health': {
        action: 'HealthCheckController.check',
        cors: {
          allowOrigins: process.env.CORS_ALLOW_ORIGINS ? process.env.CORS_ALLOW_ORIGINS.split(',') : '*',
          allowCredentials: false
        }
    },
    'POST /standard': 'StandardController.create',
    'GET /standard': 'StandardController.read',
    'GET /standard/:id': 'StandardController.readOne',
    'PUT /standard/:id': 'StandardController.update',
    'DELETE /standard/:id': 'StandardController.delete'
  };