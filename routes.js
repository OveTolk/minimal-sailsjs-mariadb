module.exports.routes = {
    'GET /': 'DefaultController.index',
    'POST /standard': 'StandardController.create',
    'GET /standard': 'StandardController.read',
    'GET /standard/:id': 'StandardController.readOne',
    'PUT /standard/:id': 'StandardController.update',
    'DELETE /standard/:id': 'StandardController.delete'
  };