{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
let
  mkConf = name: nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit nixpkgs; theFlake = self; };
    modules = [ "${self.outPath}/m/${name}/configuration.nix" ];
  };
  # For now we only support x86
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    overlays = [ self.overlays.default ];
    config.allowUnfree = true;
  };
in
  {
    nixosConfigurations = {
      hut     = mkConf "hut";
      tent    = mkConf "tent";
      owl1    = mkConf "owl1";
      owl2    = mkConf "owl2";
      eudy    = mkConf "eudy";
      koro    = mkConf "koro";
      bay     = mkConf "bay";
      lake2   = mkConf "lake2";
      raccoon = mkConf "raccoon";
      fox     = mkConf "fox";
      apex    = mkConf "apex";
      weasel  = mkConf "weasel";
    };

    bscOverlay = import ./overlay.nix;
    overlays.default = self.bscOverlay;

    # full nixpkgs with our overlay applied
    legacyPackages.${system} = pkgs;

    hydraJobs = self.legacyPackages.${system}.bsc.hydraJobs;

    # propagate nixpkgs lib, so we can do bscpkgs.lib
    lib = nixpkgs.lib // {
      maintainers = nixpkgs.lib.maintainers // {
        bsc = import ./pkgs/maintainers.nix;
      };
    };
  };
}
