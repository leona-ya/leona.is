{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    {
      overlay = final: prev: {
        leona-is-website = with final; stdenv.mkDerivation {
          name = "leona-is";
          src = self;
          buildInputs = [ zola ];
          buildPhase = "zola build -o $out";
          dontInstall = true;
        };
      };
    } // (
      flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          };
        in {
          packages.leona-is-website = pkgs.leona-is-website;
          defaultPackage = pkgs.leona-is-website;
          devShell = pkgs.mkShell {
            packages = with pkgs; [
              zola
            ];
          };
        }
      )
    );
}
