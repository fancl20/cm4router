{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 
    private.url = "git+file:private";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.cm4router = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./configuration.nix
        inputs.private.nixosModules.dae
      ];
    };
  };
}
