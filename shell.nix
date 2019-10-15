{ pkgs ? import <nixpkgs> {} }:
with pkgs;
with stdenv;
mkDerivation {
  name = "elm-blog";
  buildInputs = [
    elmPackages.elm
    elmPackages.elm-format
    nodejs-11_x
    sass
  ];
}
