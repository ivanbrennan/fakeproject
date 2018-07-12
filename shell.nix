# To update:
#   nix/update-gemset
#   nix/update-nixpkgs REVISION

{ pkgs ? (import ./nix/nixpkgs.nix) { } }:

let
  rubyenv = pkgs.bundlerEnv {
    name = "rb";

    ruby = pkgs.ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./nix/gemset.nix;

    groups = [ "default" "development" "test" ];
  };

in with pkgs; mkShell {
  name = "fakeproject";
  version = builtins.readFile ./VERSION;

  buildInputs = [
    stdenv
    git

    # Ruby deps
    ruby
    bundler
    bundix

    # Rails deps
    clang
    libxml2
    libxslt
    readline
    openssl

    rubyenv
  ];

  shellHook = ''
    export LIBXML2_DIR=${pkgs.libxml2}
    export LIBXSLT_DIR=${pkgs.libxslt}
  '';
}
