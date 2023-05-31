1 - go to https://github.com/codespaces

2 - choose the blank template

3 - Create a .devcontainer folder
`mkdir .devcontainer`

4 - Add this file 
`touch .devcontainer/devcontainer.json`

```
{
    "build": {
        "dockerfile": "Dockerfile"
    }
}
```

5 - Rebuild container (cmd + shift + p > rebuild)

6 - run `rails new . -m https://raw.githubusercontent.com/troptropcontent/devcontainer_rails/main/template.rb --database=postgresql --css tailwind`

7 - Rebuild container (cmd + shift + p > rebuild)

8 - `rails s` 🚀