{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    babashka
    clingo
    poppler-utils
    python314
  ];

  home.sessionPath = [
    "~/go/bin"
  ];

  # 仕事用メールアドレス（デフォルトの個人メールをオーバーライド）
  programs.git.settings.user.email = lib.mkForce "makoto.ito@tsukasa-ind.co.jp";

  programs.go = {
    enable = true;
    env = {
      GOPATH = "${config.home.homeDirectory}/go";
      GOPRIVATE = "github.com/tsukasa-ind/";
    };
  };
}
