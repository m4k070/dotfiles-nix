{inputs, pkgs, ...}:
  let
    inherit (import ./options.nix) username;
  in {
     home = {
       username = "${username}";
       homeDirectory = "/home/${username}";
       stateVersion = "25.11";

       packages = with pkgs; [
         git
         curl
         neovim
         htop
         ripgrep
         bat
         mise
         jq
         starship
         eza
       ];
     };

     programs.home-manager.enable = true;
     programs.zsh = {
       enable = true;
       autocd = true;
       enableCompletion = true;
       autosuggestion.enable = true;
       syntaxHighlighting.enable = true;
       shellAliases = {
         cat = "bat";
         ls = "eza --icons";
         vi = "nvim";
         vim = "nvim";
       };
       history.size = 10000;
       history.ignoreAllDups = true;
     };
     programs.git = {
       enable = true;
       settings.user.name = "Makoto Ito";
       settings.user.email = "m4k070@pm.me";
     };
     programs.gh = {
       enable = true;
       extensions = with pkgs; [gh-markdown-preview];
     };
     programs.starship = {
       enable = true;
     };

     # dotfiles を管理するならここで設定追加
     # home.file.".zshrc".text = ''
     #   export PATH=$HOME/.local/bin:$PATH
     # '';
     news.display = "silent";
  }
