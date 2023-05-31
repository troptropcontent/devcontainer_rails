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

inject_into_file '.devcontainer/Dockerfile', after: 'Rails installed' do
  <<-CODE

  ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.app.github.dev,.preview.app.github.dev"
  CODE
end