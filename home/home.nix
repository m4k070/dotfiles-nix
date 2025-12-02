{inputs, pkgs, ...}:
  let
    inherit (import ./options.nix) username;
  in {
     home = {
       username = "${username}";
       homeDirectory = "/home/${username}";
       stateVersion = "25.11";

       packages = with pkgs; [
         vim
         git
         curl
         neovim
         htop
         ripgrep
         bat
         mise
         jq
       ];
     };

     programs.home-manager.enable = true;
     programs.zsh = {
       enable = true;
       autocd = true;
       enableCompletion = true;
       # enableAutosuggestions = true;
       syntaxHighlighting.enable = true;
       shellAliases = {
         cat = "bat";
       };
     };
     programs.git = {
       enable = true;
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
