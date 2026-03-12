from dataclasses import dataclass, field
from typing import List, Optional, Final, Literal, cast
from jinja2 import Environment, FileSystemLoader
import os

BASE_DIR: Final[str] = os.path.dirname(os.path.abspath(__file__))
J2_DOCKERFILE_DIR = os.path.join(BASE_DIR, 'j2/docker')

DockerPlatform = Literal["linux/amd64"]
DockerImage = Literal["debian:12", "debian:13"]
FeaturePresets = Literal["zsh", "emacs", "qemacs"]

@dataclass
class NodejsConfig:
    version: str = "20"
    npm_global_pkgs: List[str] = field(default_factory=lambda: cast(List[str], []))

@dataclass
class ContainerConfig:
    name: str
    image_platform: DockerPlatform
    image_name: DockerImage
    tz: Optional[str] = None
    distro_pkgs: List[str] = field(default_factory=lambda: cast(List[str], []))
    '''Note that package names may differ among different distros.'''
    feature_presets: List[FeaturePresets] = field(default_factory=lambda: cast(List[FeaturePresets], []))
    '''The actual package names may differ among different distros.'''
    nodejs: Optional[NodejsConfig] = None

    @property
    def distro(self) -> Optional[str]:
        name = self.image_name.lower()
        if 'debian' in name or 'ubuntu' in name:
            return 'debian'
        if 'alpine' in name:
            return 'alpine'
        if 'suse' in name:    # 'opensuse/leap', 'opensuse/tumbleweed'
            return 'suse'
        if any(x in name for x in ['fedora', 'rocky', 'centos']):
            return 'redhat'
        return None

    @property
    def obs_repo_name(self) -> str:
        image_name = self.image_name
        low_name = image_name.lower()
        if 'debian:' in low_name:
            return image_name.replace('debian:', 'Debian_')
        if 'ubuntu:' in low_name:
            return image_name.replace('ubuntu:', 'xUbuntu_')
        if 'tumbleweed' in low_name:
            return 'openSUSE_Tumbleweed'
        if 'slowroll' in low_name:
            return 'openSUSE_Slowroll'
        if 'leap:' in low_name:
            return image_name.split(':')[1]
        if any(x in low_name for x in ['fedora', 'rocky', 'centos']):
            return image_name.capitalize().replace(':', '_')
        return ""

CONTAINERS = [
    ContainerConfig(
        name="claude",
        image_platform="linux/amd64",
        image_name="debian:12",
        tz="Asia/Taipei",
        distro_pkgs=[],
        feature_presets=['zsh', 'qemacs'],
        nodejs=NodejsConfig(
            npm_global_pkgs=["@anthropic-ai/claude-code"]
        )
    ),
    ContainerConfig(
        name="codex",
        image_platform="linux/amd64",
        image_name="debian:12",
        tz="Asia/Taipei",
        distro_pkgs=["links2"],
        feature_presets=['zsh', 'qemacs'],
        nodejs=NodejsConfig(
            npm_global_pkgs=["@openai/codex"]
        )
    )
]

def render_configs():
    j2_docker = Environment(loader=FileSystemLoader(J2_DOCKERFILE_DIR))

    for cfg in CONTAINERS:
        df_template = j2_docker.get_template('Dockerfile.j2')
        with open(f"Dockerfile.{cfg.name}", "w") as f:
            f.write(df_template.render(cfg=cfg))

        print(f"Generated files for {cfg.name}")

if __name__ == "__main__":
    render_configs()