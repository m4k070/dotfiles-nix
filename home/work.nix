{ config, pkgs, noctalia, nixgl, lib, ... }: {
  imports = [
    ./base.nix
    noctalia.homeModules.default
  ];

  # nixGL を使ってGPUドライバーをラップする（非NixOS環境向け）
  targets.genericLinux.nixGL.packages = import nixgl {
    inherit pkgs;
  };
  targets.genericLinux.nixGL.defaultWrapper = "mesa";
  targets.genericLinux.nixGL.installScripts = [ "mesa" ];

  home.packages = with pkgs; [
    (config.lib.nixGL.wrap alacritty)
    (config.lib.nixGL.wrap wezterm)
    libreoffice
    mysql80
    poppler-utils
    postgresql
    remmina
    # teams-for-linux
    zoom-us
  ];

  home.sessionPath = [
    "~/go/bin"
  ];

  programs.ghostty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.ghostty;
    enableZshIntegration = true;
    settings = {
      font-size = 14;
      font-family = "UDEV Gothic";
      theme = "noctalia";
      shell-integration-features = "ssh-env";
    };
  };

  # デフォルトの個人メールアドレスを仕事用にオーバーライド
  programs.git.settings.user.email = lib.mkForce "makoto.ito@tsukasa-ind.co.jp";

  programs.go = {
    enable = true;
    env = {
      GOPATH = [
        "${config.home.homeDirectory}/go"
      ];
      GOPRIVATE = [
        "github.com/tsukasa-ind/"
      ];
    };
  };

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
  };
}
