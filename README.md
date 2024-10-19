# Monorepo for Rails GraphQL API and Vite + React SPA

This monorepo hosts two main applications:
- A **Rails GraphQL API** running in API mode located in `./backend`
- A **Vite + React Single Page Application (SPA)** located in `./frontend`

## Project Structure

```bash
$ tree -L 2
.
├── backend                  # Rails GraphQL API (API mode)
│   ├── Dockerfile           # Dockerfile for the Rails backend
│   ├── Gemfile              # Gem dependencies
│   ├── Gemfile.lock
│   ├── README.md
│   ├── app                  # Rails application code
│   ├── config               # Rails configuration
│   ├── public               # Contains compiled frontend assets
│   ├── spec                 # RSpec tests
│   └── ...
├── frontend                 # Vite + React SPA
│   ├── README.md
│   ├── package.json         # Frontend dependencies and scripts
│   ├── src                  # React source code
│   ├── dist                 # Build output for the frontend app
│   └── ...
└── graphql-schema           # GraphQL schema files
    └── backend_schema.graphql
```

## Backend Development

The backend is a Rails application running in API mode. Below are the key steps for setting up and running the backend:

1. **Managing Dependencies**
   To install backend dependencies, use Bundler to install all gems from the `Gemfile`:
   ```bash
   # cd ./backend
   bundle install
   ```

2. **Database Setup**
   Ensure the database is properly set up. You can spin up the required services using Docker Compose:
   ```bash
   # cd ./backend
   docker compose up -d
   ```

3. **Initial Setup**
   To initialize the application (e.g., creating the database, running migrations), run the setup script:
   ```bash
   # cd ./backend
   bin/setup
   ```

4. **Start Server**
   To start the Rails server for development, use the following command:
   ```bash
   # cd ./backend
   bin/dev
   ```

5. **Run Tests**
   To run the test suite, use RSpec:
   ```bash
   # cd ./backend
   bundle exec rspec
   ```

## `graphql-schema` Directory and GraphQL Schema Code-First Approach

This project adopts a **Code-First** approach to defining GraphQL schemas using the `graphql-ruby` gem. Here’s how the backend and frontend integrate using GraphQL schemas:

1. **Update GraphQL Schema in Backend**
   Use the available rake task in the backend to update the GraphQL schema and output it to the `graphql-schema` directory:
   ```bash
   # cd ./backend
   bin/rails graphql:schema:dump
   ```

2. **Generate TypeScript Types in Frontend**
   Run the following command in the frontend to generate TypeScript types based on the updated GraphQL schema:
   ```bash
   # cd ./frontend
   bun run graphql-codegen
   ```

   This process ensures that the types are correctly synchronized between the backend and frontend, facilitating type-safe GraphQL queries in the frontend.

## Frontend Development

The frontend is a Vite-powered React SPA, and Bun is used as the package manager. The primary build scripts are defined in `frontend/package.json`:

```json
{
  "name": "my-spa",
  "packageManager": "bun@1.1.31",
  "private": true,
  "scripts": {
    "prepare": "panda codegen",
    "dev": "vite",
    "build": "tsc -b && vite build",
    "build:move": "bun run build && bun run move-assets",
    "move-assets": "rsync -av --delete dist/index.html ../backend/public/ && rsync -av --delete dist/assets/ ../backend/public/assets/ && touch ../backend/public/assets/.keep",
    "preview": "vite preview",
    "graphql-codegen": "graphql-codegen"
  }
}
```

Key commands include:
- `bun run dev`: Starts the Vite development server for live preview.
- `bun run build`: Builds the production assets for deployment.
- `bun run build:move`: Builds the frontend and moves the build artifacts into the Rails public directory.
- `bun run graphql-codegen`: Generates TypeScript types from the GraphQL schema.

## Deployment Process

🚧 ~under construction~

The deployment process involves building the frontend, syncing the build artifacts to the Rails `public/` directory using `rsync`, and building the Docker image for the Rails API.

### Steps:

1. **Build the frontend and Move frontend build artifacts to Rails**
   Navigate to the `frontend` directory and run the build command using Bun. This compiles the React app and outputs the assets to `backend/public/assets`:
   ```bash
   cd frontend && bun run build:move
   ```

2. **Build the Docker image**
   After the assets are moved, the Rails backend can be built into a Docker image:
   ```bash
   cd backend && docker build -t my-spa .
   ```

3. **Deploy**
   Deploy the application using your preferred method (e.g., Docker Compose, Kubernetes, or any CI/CD pipeline).

## Key Features of the Rails Application

The Rails API serves as the backend for the SPA and manages authentication and routing for the client. Below are some technical highlights of the Rails setup.

### Routing and Static Assets

The Rails application serves the frontend SPA's assets for specific routes listed in `config/routes.rb`. These routes point to a static controller, which renders the `index.html` file generated by the frontend.

```ruby
# config/routes.rb
to = "static#index"
[
  "/login",
  "/me",
  "/onboarding/verify_email_address",
  "/set_password",
  "/signup",
].each { get _1, to: }
```

The `StaticController` reads the `index.html` from the `public` directory and serves it as the response for these routes:

```ruby
# app/controllers/static_controller.rb
class StaticController < ApplicationController
  def index
    response.headers['Content-Type'] = 'text/html'
    render plain: Rails.public_path.join('index.html').read, layout: false
  end
end
```

### Cookie Management

The Rails API uses `ActionController::Cookies` to manage cookie-based authentication and sessions, even though it runs in API mode. This allows for integration with client-side authentication flows.

```ruby
class ApplicationController < ActionController::API
  include ActionController::Cookies
end
```

This setup ensures that cookies are properly handled across the application, which is important for features such as authentication, user sessions, and cross-origin requests.
