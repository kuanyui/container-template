# OS
- Debian 12 (bookworm) x86_64

# System Settings
- Timezone is set to `Asia/Taipei`.

# Preinstalled Third-Parties Softwares
- `nodejs 14` via `nvm` (you can use specify a newer version via editing `Dockerfile`)
- `ImageMagick 7.1.1` via ImageMagick official AppImage (because Debian official repos only provides up to `6.x` which is too old and doesn't provide `magick` command)
- `qemacs` for those who don't get used to vim. (built via openSUSE OBS, the
  build process is transparent and auditable.)