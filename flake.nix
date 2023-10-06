{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { inputs', pkgs, ... }:
        let opkgs = pkgs.ocamlPackages; in
        {
          packages.default = opkgs.buildDunePackage {
            pname = "ppx_inline_interface";
            version = "dev";

            src = ./.;
            duneVersion = "3";

            buildInputs = with opkgs; [
              ppxlib
            ];
          };
        };
    };
}
