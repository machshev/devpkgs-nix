{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv

    # Common
    gnumake
    git
    git-interactive-rebase-tool
    typos-lsp
    gh
    direnv
    tokei

    # Asm
    asm-lsp

    # WASM
    wabt

    # Lua
    lua-language-server
    stylua

    # Zig
    zig
    zls

    # C
    gcc
    #clang
    maim
    conky

    # Nix
    nil

    # Node
    nodejs

    # Shell
    shellcheck
    shfmt
    nodePackages.bash-language-server

    # ansible
    ansible-language-server
    ansible-lint

    # Docker
    docker-compose

    # libvirt
    virt-manager

    # terraform
    opentofu
    terraform-ls # opentofu-ls not yet included
    google-cloud-sdk
    yamllint
    yaml-language-server

    # eda
    usbutils

    # Security
    wireshark

    # Programmers
    #segger-ozone
    openssl.dev

    # Misc [old]
    v4l-utils
    vlc
  ];
}
