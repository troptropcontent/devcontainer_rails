file '.devcontainer/docker-compose.yml', <<-CODE
  version: '3'

  services:
    app:
      build:
        context: ..
        dockerfile: .devcontainer/Dockerfile
        args:
          VARIANT: "3.1-bullseye"
      volumes:
        - ..:/workspace:cached
      command: sleep infinity
      network_mode: service:db
      user: vscode

    db:
      image: postgres:latest
      restart: unless-stopped
      volumes:
        - postgres-data:/var/lib/postgresql/data
      environment:
        POSTGRES_USER: postgres
        POSTGRES_DB: postgres
        POSTGRES_PASSWORD: postgres

  volumes:
    postgres-data:
CODE

run 'rm -f .devcontainer/Dockerfile'

file '.devcontainer/Dockerfile', <<-CODE
ARG VARIANT=3.1-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/ruby:${VARIANT}

RUN gem install rails 
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.app.github.dev,.preview.app.github.dev"
CODE

run 'rm -f .devcontainer/devcontainer.json'

file '.devcontainer/devcontainer.json', <<-CODE
  {
    "name": "Ruby on Rails & Postgres",
    "dockerComposeFile": "docker-compose.yml",
    "service": "app",
    "workspaceFolder": "/workspace",
    "customizations": {
      "vscode": {
        "extensions": [
          "rebornix.Ruby"
        ]
      }
    },
    "forwardPorts": [3000, 5432],
    "postCreateCommand": "bundle install && rails db:setup",
    "remoteUser": "vscode"
  }
CODE

inject_into_file 'config/database.yml', after: 'pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>' do
<<-RUBY

  host: db
  username: postgres
  password: postgres
RUBY
end

inject_into_file 'config/environments/development.rb', after: 'config.assets.quiet = true' do
<<-CODE
# Setup preview in simple browser
pf_domain = ENV['GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN']
config.action_dispatch.default_headers = {
  'X-Frame-Options' => "ALLOW-FROM \#{pf_domain}"
}

pf_host = "\#{ENV['CODESPACE_NAME']}-3000.\#{pf_domain}"
config.hosts << pf_host

config.action_cable.allowed_request_origins = ["https://\#{pf_host}"]
CODE
end

gem_group :development do
  gem "foreman"
end

gem_group :development, :test do
  gem "byebug"
end

if yes?("Are you interested in my custom vscode settings ?")
  run 'mkdir .vscode'
  run "curl -o .vscode/erb.code-snippets 'https://raw.githubusercontent.com/troptropcontent/vs-code-settings/main/.vscode/.code-snippets'"
  run "curl -o .vscode/settings.json 'https://raw.githubusercontent.com/troptropcontent/vs-code-settings/main/.vscode/settings.json'"
end

after_bundle do
  run 'rm -f bin/dev'
  file 'bin/dev', <<-CODE
  #!/usr/bin/env sh

  exec foreman start -f Procfile.dev "$@"
  CODE

  git add: '.'
  
  git commit: %Q{ -m 'Firt commit after template modification' }
end