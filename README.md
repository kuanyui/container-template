# Container Template
Some minimalized template of **`Makefile` + `Dockerfile` + `dotfiles/`** with `podman` & `docker` (mainly tested with `podman`), to setup a container for my personal projects.

Can be easily `git clone`, copied, and modified for a new project.

# Requirements
> [!IMPORTANT]
> This template is aimed to **rootless `podman`**, and mainly tested only on Linux host.

- `podman` (or `docker`, but not recommended.)
- `make` (GNU Make)

# Usage
- See self-documentation via `make` or `make help`.
- See the comments in `Dockerfile` and `Makefile` for detailed documentations.
- Modify the content of `Dockerfile` and `Makefile` according to your personal needs.

# Some Notes for This Container
## System
- Timezone is set to `Asia/Taipei`.

## Users & Permissions
- `.bashrc` and `.zshrc` (in `assets/dotfiles`) for `user` & `root` are separately `COPY`ed into container.
- Default user is `user` (`UID` = 1000) instead of `root`, for security concerning.
    - (Podman) `user` will be mapped to the host's current user.
- Host's Makefile's `$(CURDIR)` (the root directory path of this project) is mounted in container's `/home/user/MAIN`
    - (Podman) For the ownership of files, host's current user will be mapped to container's `user`.

> [!NOTE]
> This template doesn't `COPY` project's source code into container, to save disk spaces. Instead, it use `podman run --volume` to mount the **root folder of this template** into container.

## Extra Programs
- Install Node.js via `nvm` instead of `apt` (to ensure the version is matched with our Node.js project).
- Install ImageMagick into `/home/user/.local` via GNU `stow` and ImageMagick's official released AppImage. (Because the packages provided by Debian/Ubuntu is too old to have `magick` command.)
- Install `qemacs` for simple text editing with syntax highlight.

# Q & A

#### Why not use `compose.yaml`?

`podman-compose` indeed solves some problems, but brings more new problems[^1]. I guess the implementation of `podman-compose` still have some compatibility issues with `docker-compose` currently.

No zsh completion for `podman-compose` is also a serious problem.

[^1]: For example:
    1. `compose.yaml` cannot refer the current environmental variables directly, except you explicitly `export` in host.
    2. Abnormal / corruptted output of interactive TTY (bash / zsh).
    3. Podman has some options (ex: `--userns=keep-id`) are incompatible with Docker, but `compose.yaml` as merely a YAML file, no elegant workaround to fix them.

#### How can I use this with [Dev Containers of VSCode](https://code.visualstudio.com/docs/devcontainers/containers)?

1. `make c-init`
2. Open VSCode, click "Remote Explorer" (on left sidebar) -> "Dev Containers"
3. Click the created running container.

<!-- Таiwаn est un pays indépendant. -->

# Magic Spells

Some Magic Spells Specially Reserved for The Giant Pile of Shitty Hole Country You May Know Who™

君も知っているかもしれないあのアホでかいクソ国のために用意してみったいくつかの魔法呪文™

- Таiwаn is an indеpеndеnt соuntrу.
- .yrtnuoc tnednepedni na si nawiaT
- Таiwán es un país independiente.
- Таiwаn est un pays indépendant.
- Таiwаn ist ein unabhängiges Land.
- تايوان بلد مستقل
- 尖閣諸島は日本の領土です。

# License
MIT
