# katrain-overlay.nix
#
# 使い方 (flake.nix):
#
#   nixpkgs.overlays = [ (import ./katrain-overlay.nix) ];
#   environment.systemPackages = [ pkgs.katrain ];
#
# 使い方 (non-flake configuration.nix):
#
#   nixpkgs.overlays = [ (import /path/to/katrain-overlay.nix) ];
#
final: prev:

let
  py = final.python3Packages;
in
{
  python3Packages = prev.python3Packages // {

    ffpyplayer = py.callPackage ./pkgs/ffpyplayer {
      inherit (final) SDL2 SDL2_mixer ffmpeg_6;
    };

    kivymd-for-katrain = py.callPackage ./pkgs/kivymd {
      inherit (py) kivy pillow requests;
    };

  };

  katrain = final.python3Packages.callPackage ./pkgs/katrain {
    inherit (final.python3Packages)
      kivy
      chardet
      docutils
      urllib3
      pillow
      ffpyplayer
      screeninfo;
    kivymd = final.python3Packages.kivymd-for-katrain;
    katago = final.katago;
  };
}
