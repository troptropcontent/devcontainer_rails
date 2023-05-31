1 - go to https://github.com/codespaces

2 - choose the blank template

3 - Create a .devcontainer folder

4 - Add those two files 

Dockerfile

```
ARG VARIANT=3.1-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/ruby:${VARIANT}

RUN gem install rails 
```

devcontainer.json

```
{
    "build": {
        "dockerfile": "Dockerfile"
    }
}
```

5 - Rebuild container (cmd + shift + p > build)

6 - run rails new . -m https://raw.githubusercontent.com/troptropcontent/devcontainer_rails/main/template.rb --database=postgresql --css tailwind

7 - rebuild and youre good to go