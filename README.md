1 - go to https://github.com/codespaces

2 - choose the blank template

3 - Create a .devcontainer folder
`mkdir .devcontainer`

4 - Add a devcontainer.json file inside  
```
echo -e "{\n	\"name\": \"Ruby and Rails\",\n	\"image\": \"mcr.microsoft.com/devcontainers/ruby:0-3.1-bullseye\",\n	\"postCreateCommand\": \"gem install rails\"\n}" > .devcontainer/devcontainer.json
```

5 - Rebuild container (cmd + shift + p > rebuild)

6 - run 
```
rails new . -m https://raw.githubusercontent.com/troptropcontent/devcontainer_rails/main/template.rb --database=postgresql --css tailwind
```

7 - Rebuild container (cmd + shift + p > rebuild)

8 - `rails s` 🚀

