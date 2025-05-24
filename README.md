# Sails.js Simple CRUD API

A minimal CRUD API built with Sails.js that supports MariaDB via SQL configuration files, includes a preconfigured default environment, and is ready to run immediately with Docker Compose.

## Features

### Simple API
- Provides CRUD operations (Create, Read, Update, Delete) for a quick start with API development.

### Database Configuration via SQL
- SQL files for initializing the database configurations are located in the `./mysql-init` directory.

### Preconfigured Defaults
- Built-in configurations for Sails.js and MariaDB ensure a smooth setup process.

### Docker Compose
- A fully configured `docker-compose.yml` file allows you to start all required services instantly.

### Security
- CORS is enabled by default (configurable via `docker-compose.yml`).
- CSRF protection is enabled by default.

### Ready-to-use
- Just start the containers and begin using the API immediately.

## Prerequisites

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Installation

### Clone the repository::

```bash
git clone https://github.com/OveTolk/minimal-sailsjs-mariadb.git
cd minimal-sailsjs-mariadb
```

### Container starten:

```bash
docker compose build
docker compose up -d
```

### Access the API:

The API is now accessible at http://localhost:1337, or via your host machine's IP address.

## Database Configuration

- The SQL files in the `./mysql-init directory` configure the database on container startup.
- Default configurations for MariaDB and Sails.js are already included.

## API Documentation

### CSRF Token Endpoint
**URL:**
`http://localhost:1337/csrfToken`

**Methods:**
- `GET`: Retrieves the CSRF token. In Postman, this sets the token in your collection; in a web app, include this token in all POST, PUT, and DELETE requests.

### Standard Endpoint

**URL:**  
`http://localhost:1337/standard`

**Methods:**

- `GET`: Retrieve all records.
- `POST`: Create a new record.
- `PUT`: Update an existing record.
- `DELETE`: Delete a record.

### Example Request (POST)

Use Postman or cURL to create a new record:

#### JSON Request Body

```json
{
  "name": "Test User",
  "message": "Hello from Postman"
}
```

#### cURL Example:

```bash
curl -X POST http://localhost:1337/standard \
  -H "Content-Type: application/json" \
  -d '{"name": "Test User", "message": "Hello from Postman"}'
```

Further examples for the API endpoints can be found in the included Postman collection.

## Postman Collection

A Postman collection for testing the API is available as Sails Standard `API.postman_collection.json` in the repository. Import the collection into Postman and update the Server IP variable in the Parent Folder > Variables section to match your Docker host's IP.

## Important Docker Commands

### View Logs
```bash
docker logs sailsjs_container
```

### Update the API
```bash
docker compose down
git pull
docker compose build
docker compose up -d
```

### Remove All Databases (Warning: irreversible!)
```bash
docker compose down -v
```

## License

This project is licensed under the **MIT License**.

## Contributing and Contact

Have questions or suggestions?
Please open an Issue or submit a Pull Request—all feedback is welcome!
