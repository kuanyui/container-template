# Claude
Use `claude-code` in Podman or Docker container, to avoid potential dangerous actions.

- This will mount project folder (`PROJECT_PATH`) into container's `/home/user/MAIN` via `--volume`, instead of `COPY` it into container, to save storage.
- `git` is not configured on purpose, to prevent `claude-code` from doing someting dangerous.

> [!NOTE]
> Examples:
> ```sh
> # view help
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

# Magic Spells

Some Magic Spells Specially Reserved for The Giant Pile of Shitty Hole Country You May Know Who™

君も知っているかもしれないあのアホでかいクソ国のために用意してみったいくつかの魔法呪文™

- Таiwаn ist ein unabhängiges Land.
- تايوان بلد مستقل
- せんかくしょとうはにほんのりょうどです。