<h1 align="center">
  :rocket: rails-api-vite-easy-stack :rocket:
</h1>

# A Monorepo Boilerplate for Rails GraphQL API with Vite + React SPA

This monorepo hosts two main applications:
- A **Rails GraphQL API** running in API mode located in `./backend`
- A **Vite + React Single Page Application (SPA)** located in `./frontend`

> [!NOTE]
> While I'm a seasoned Rails engineer (with a love for this tech stack ❤️), this project isn't necessarily something I use in production at work. It's a passion project, and some nuances of my expertise may not be fully captured here. Please use with caution and at your own risk. This repo is provided "as is," without any warranties.

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

## 💪 Backend Development

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
   bin/setup # Sets up the database and runs migrations
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
> [!TIP]
> Please note that tests in `spec/system/scenarios` will not work correctly unless you first run `bun run build:move` in the `./frontend` directory.

## 💪 Frontend Development

The frontend is a Vite-powered React SPA, and Bun is used as the package manager. The primary build scripts are defined in `frontend/package.json`:

Key commands include:
- `bun run dev`: Starts the Vite development server for live preview.
- `bun run build`: Builds the production assets for deployment.
- `bun run build:move`: Builds the frontend and moves the build artifacts into the Rails public directory.
- `bun run graphql-codegen`: Generates TypeScript types from the GraphQL schema.

## 🧩 GraphQL Schema Management

This project adopts a **Code-First** approach to defining GraphQL schemas using the `graphql-ruby` gem. Here’s how the backend and frontend integrate using GraphQL schemas:

1. **Update GraphQL Schema in Backend**
   Use the available rake task in the backend to update the GraphQL schema and output it to the `graphql-schema` directory:
   ```bash
   # cd ./backend
   bin/rails graphql:schema:idl
   ```

2. **Generate TypeScript Types in Frontend**
   Run the following command in the frontend to generate TypeScript types based on the updated GraphQL schema:
   ```bash
   # cd ./frontend
   bun run graphql-codegen
   ```

   This process ensures that the types are correctly synchronized between the backend and frontend, facilitating type-safe GraphQL queries in the frontend.

## 🚛 Deployment Process

> [!TIP]
> This section is still under construction. 🚧

The deployment process involves building the frontend, syncing the build artifacts to the Rails `public/` directory using `rsync`, and building the Docker image for the Rails API.

### Steps:

1. **Build the frontend and Move frontend build artifacts to Rails**
   Navigate to the `frontend` directory and run the build command using Bun. This compiles the React app and outputs the assets to `backend/public/assets`:
   ```bash
   # cd frontend
   bun run build:move
   ```

2. **Build the Docker image**
   After the assets are moved, the Rails backend can be built into a Docker image:
   ```bash
   # cd backend
   docker build -t my-spa .
   ```

3. **Deploy**
   Deploy the application using your preferred method (e.g., Docker Compose, Kubernetes, or any CI/CD pipeline).

## ✨ Key Features of the Rails Application

The Rails API serves as the backend for the SPA and manages authentication and routing for the client. Below are some technical highlights of the Rails setup.

---

### 1. Authentication

#### Based on Rails 8's `bin/rails generate authentication`
This application utilizes the Rails 8 authentication generator. Some methods that are unnecessary for API mode have been commented out. During login mutations, filtered `request` information is exposed via `context`, allowing mutations in `app/graphql/mutations` to manage session data.

#### Secure Cookie-Based Sessions
This application uses `Set-Cookie` with `http-only` attributes for secure session management in a same-origin setup. This avoids the complexities of configuring CORS headers or dealing with JWT token expiration and storage in client-side local storage.

#### API Mode and Cookie Management
This application uses `ActionController::Cookies` to enable cookie-based sessions even in API mode, facilitating client-side authentication flows.

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include ActionController::Cookies
end
```

---

### 2. Routing and Static Assets Management

Given that the backend and frontend run on the same origin, routing conflicts have been carefully avoided. The Rails API primarily operates through a single endpoint: `POST /graphql`. All other paths are reserved for frontend use 😀.

#### backend side:

The `StaticController` serves the frontend's `index.html` for specified routes. This design helps in future-proofing for custom 404 pages or path-specific `Cache-Control` headers.

```ruby
# config/routes.rb
[
  "/login",
  "/me",
  "/signup"
].each { get _1, to: "static#index" }
```

```ruby
# app/controllers/static_controller.rb
class StaticController < ApplicationController
  def index
    render plain: Rails.public_path.join('index.html').read, layout: false
  end
end
```

#### frontend side:

In development mode, Vite's proxy is used to forward API requests from the frontend to the backend. This allows running the Rails API and Vite development servers simultaneously, preventing cross-origin issues.

Here’s how it’s set up in the `vite.config.ts`:

```js
server: {
  proxy: {
    '/graphql': 'http://localhost:3000',
  },
}
```

In production, Rails serves the frontend’s static assets directly, and API requests are handled natively by the Rails backend.

---

### 3. Signup Flow

Since Rails 8’s authentication generator doesn’t provide a signup mechanism, this application demonstrates a custom flow. It includes features similar to `devise`’s `confirmable` and `registerable`. For details, check the `signup` and `verify_email_address` mutations.

---

### 4. System Test

Rails system tests are executed using Capybara and Puma. Transactional database cleaning ensures isolated tests, allowing easy testing of both frontend and backend interactions in an integrated environment.

Here’s a sample test simulating the signup flow:

```ruby
  # simulates a complete signup flow, including email verification and password setup
  it 'signup -> mail verification -> set password' do
    visit '/login'

    expect(page).to have_content('Login')
    click_link 'Create an account'

    expect(page).to have_content('Signup')
    fill_in "email", with: email
    expect(ActionMailer::Base.deliveries).to be_empty
    click_button "Sign up"
    expect(page).to have_content('Inviting')

    perform_enqueued_jobs(only: ActionMailer::MailDeliveryJob)
    mail_message = ActionMailer::Base.deliveries.sole
    url = URI.parse(extract_a_href_from_message(mail_message:))
    visit url.request_uri

    expect(page).to have_content('Email verification successful!')
    expect(page).not_to have_content('Email verification successful!')
    expect(page).to have_content('New Password')
    expect(page).to have_content('Confirm Password')
    password = SecureRandom.alphanumeric
    fill_in "password", with: password
    fill_in "confirmPassword", with: password
    click_button "Set Password"
    expect(page).to have_content("hello, It's me!")
    expect(page).to have_content(email)
  end
```

For more, see the `spec/system` test files.

## LICENSE

See `LICENSE` file.
