{ pkgs, inputs, ... }:

let
  # Compile kwm using the recipe in ./pkgs/kwm.nix and the raw source code
  kwm = pkgs.callPackage ./pkgs/kwm.nix {
    src = inputs.kwm-src;
  };
in
{
  home.username = "siyath";
  home.homeDirectory = "/home/siyath";
  home.stateVersion = "24.11";

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https"; # Using https
    };
  };

  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # omz
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "gallifrey";
    };
  };

  # Install the compiled kwm package
  home.packages = [
    kwm
    pkgs.gh
  ];

  # Declaratively generate ~/.config/kwm/config.zon
  xdg.configFile."kwm/config.zon".text = ''
    // Your custom kwm runtime configuration options go here
  '';

  programs.home-manager.enable = true;
}
