{
  description = "NixOS System and Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fetch raw source code
    kwm-src = {
      url = "github:kewuaa/kwm";
      flake = false;
    };

    wezterm-config = {
      url = "github:kineticacapella/wezterm-config";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, kwm-src, wezterm-config, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          
          home-manager.users.siyath = { pkgs, inputs, ... }: (import ./home.nix) { pkgs = pkgs; inputs = inputs; };
        }
      ];
    };
  };
}
