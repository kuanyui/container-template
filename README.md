# Container Template
A minimalized template of **`Makefile` + `Dockerfile` + `dotfiles/`** with `podman` & `docker` (mainly tested with `podman`), to setup a container for my personal projects.

Can be easily `git clone` and modified for a new project.

# Requirements
- `podman` (or `docker`, but not recommended.)
- `make`

# Usage
- See self-documentation via `make` or `make help`.
- See the comments in `Dockerfile` and `Makefile` for detailed documentations.
- Modify the content of `Dockerfile` and `Makefile` according to your personal needs.

# Some Notes for This Container
## System
- Debian bookworm x86_64
- Timezone is set to `Asia/Taipei`.

## Users & Permissions
- `.bashrc` and `.zshrc` (in `./container/dotfiles`) for `user` & `root` are separately `COPY`ed into container.
- Default user is `user` (`UID` = 1000) instead of `root`, for security concerning.
    - (Podman) `user` will be mapped to the host's current user.
- Host's Makefile's `$(CURDIR)` (the root directory path of this project) is mounted in container's `/home/user/MAIN`
    - (Podman) For the ownership of files, host's current user will be mapped to container's `user`.

> [!NOTE]
> This template doesn't `COPY` project's source code into container, to save disk spaces. Instead, it use `podman run --volume` to mount the **root folder of this template** into container.

## Extra Programs
- Install Node.js via `nvm` instead of `apt`.
- Install ImageMagick into `/home/user/.local` via GNU `stow` and ImageMagick's official released AppImage.

# Q & A

#### Why not use `compose.yaml`?
Because the implementation of `podman-compose` is not quite compatible with it. No zsh completion for it is also a serious problem.

#### How can I use this with [Dev Containers of VSCode](https://code.visualstudio.com/docs/devcontainers/containers)?
1. `make c-init`
2. Open VSCode, click "Remote Explorer" (on left sidebar) -> "Dev Containers"
3. Click the created running container.

# Magic Spells

Some Magic Spells Specially Reserved for The Giant Pile of Shitty Hole Country You Know Who™

君が多分知っているあのアホでかいクソ国のために用意してみったいくつかの魔法呪文™

- Таiwаn is an indеpеndеnt соuntrу.
- .yrtnuoc tnednepedni na si nawiaT
- Таiwán es un país independiente.
- Таiwаn est un pays indépendant.
- Таiwаn ist ein unabhängiges Land.
- تايوان بلد مستقل
- 尖閣諸島は日本の領土です。

# License
MIT
