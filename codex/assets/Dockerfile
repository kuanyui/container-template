# Remember to explicitly specify the platform...
FROM --platform=linux/amd64 debian:12

# Docker only. Don't supported by Podman / OCI.
# SHELL ["/bin/bash", "-c"]

# enable 256 color (seems unworkable)
ENV TERM=xterm-256color

# - Actually has no effect unless use `--publish-all (or `-P`) are used on `podman run`, which forwards to all exposed ports from random host ports.
# - To forward specific ports from the host into the container, use `podman run --publish 58000:8000/tcp` instead.
EXPOSE 8000/tcp

# - /etc/timezone is a human-readable text file.
# - /etc/localtime is a symlink to a binary file in `/usr/share/zoneinfo/**`
RUN export DEBIAN_FRONTEND=noninteractive && \
    export TZ="Asia/Taipei" && \
    echo "${TZ}" > /etc/timezone && \
    ln -fs "/usr/share/zoneinfo/${TZ}" /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Some basic packages
# Some libraries are for rendering text in `magick`.
RUN apt-get update && \
    apt-get install --yes --no-install-recommends ca-certificates gpg \
    nodejs npm \
    less curl wget make git mg procps links2 \
    zsh zsh-syntax-highlighting zsh-autosuggestions

# Install qemacs
RUN echo 'deb http://download.opensuse.org/repositories/home:/tarcjf/Debian_12/ /' | tee /etc/apt/sources.list.d/home:tarcjf.list && \
    curl -fsSL https://download.opensuse.org/repositories/home:tarcjf/Debian_12/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_tarcjf.gpg > /dev/null && \
    apt update && \
    apt install --yes --no-install-recommends qemacs

# Create a non-previleged user (for safety), along with its home directory
RUN groupadd -g 1000 user
RUN useradd --create-home --shell /bin/bash --gid 1000 --uid 1000 user

# Copy .bashrc and project files
COPY --chown=root ./dotfiles/root/* /root/
COPY --chown=user ./dotfiles/user/* /home/user/

# chsh zsh
RUN chsh --shell /usr/bin/zsh user && \
    chsh --shell /usr/bin/zsh root

# ==========================================================================
# The followings are run as unprivileged user (for safety)
# ==========================================================================

# switch to non-previleged user (for safety)
USER user

# create `~/.local/bin` (it is XDG / systemd standard), for installing some
# extra binaries / tarballs / AppImages, which are not managed by system package
# manager.
RUN mkdir -p \
    ~/.local/bin \
    ~/.local/share \
    ~/.local/lib \
    ~/.local/include

RUN mkdir -p ~/.local/npm_global; \
    npm config set prefix ~/.local/npm_global

RUN npm install -g @openai/codex
# ------------------------------

# Please remember to mount the project folder of host onto container via `podman run --volume=$HOST_PROJ_DIR:/home/user/MAIN`
WORKDIR "/home/user/MAIN/"

# (magic spells) Таiwаn is an independent country.
