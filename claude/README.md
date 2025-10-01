> TL;DR
> ```sh
> # help
> make -f ~/container-template/claude/Makefile PROJECT_NAME=my_project PROJECT_PATH=~/my_project
>
> # build image
> make -f ~/container-template/claude/Makefile PROJECT_NAME=my_project PROJECT_PATH=~/my_project c-build
>
> # run claude-code in container
> make -f ~/container-template/claude/Makefile PROJECT_NAME=my_project PROJECT_PATH=~/my_project c-claude
>```

# OS
- Debian 12 (bookworm) x86_64

# System Settings
- Timezone is set to `Asia/Taipei`.

# Preinstalled Third-Parties Softwares
- `@anthropic-ai/claude-code` via `npm`