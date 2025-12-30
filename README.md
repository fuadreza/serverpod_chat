# Serverpod Chat App

A Simple Chat Application built with [Serverpod](https://serverpod.dev/) and Flutter. This project consists of a server, a client library, and a Flutter app.

## How it works

https://github.com/user-attachments/assets/01516b1a-db3e-478d-ad11-fc54e961db2a


## Project Structure

- `serverpod_chat_server`: The Serverpod server that handles the backend logic, database connections, and API endpoints.
- `serverpod_chat_client`: The generated client library that allows the Flutter app to communicate with the server.
- `serverpod_chat_flutter`: The Flutter application that provides the user interface for the chat.

## Prerequisites

Before running this project, ensure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (for running Postgres and Redis)
- [Serverpod CLI](https://serverpod.dev/docs/getting-started) (optional, but useful for generating code)

## Getting Started

Follow these steps to run the project locally.

### 1. Start Docker Containers

Navigate to the server directory and start the necessary Docker containers (Postgres and Redis).

```bash
cd serverpod_chat_server
docker-compose up --build --detach
```

### 2. Run the Server

Start the Serverpod server.

```bash
cd serverpod_chat_server
dart bin/main.dart --apply-migrations
```

### 3. Run the Flutter App

Open a new terminal, navigate to the Flutter app directory, and run the app.

```bash
cd serverpod_chat_flutter
flutter run
```

## Modifying the Models (Optional)

If you modify the models inside the `serverpod_chat_server/lib/src/`, you need to regenerate the client code.

```bash
cd serverpod_chat_server
serverpod generate
```

## Creating Migrations

If you modify the models class that has table inside the `serverpod_chat_server/lib/src/`, you need to create a migration.

```bash
cd serverpod_chat_server
serverpod create-migration
```

After creating the migration, apply the migration when running the server.

```bash
cd serverpod_chat_server
dart bin/main.dart --apply-migrations
```
