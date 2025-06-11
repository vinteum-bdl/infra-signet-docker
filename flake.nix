{
  description = "Bitcoin signet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
        inputs.devshell.flakeModule
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        #packages.default = pkgs.hello;

        devshells.default = with pkgs; {
          devshell.name = "btc-docker";

          # Programs you want to make available in the shell.
          packages = [
            # colima
            docker
          ] ++ lib.optionals stdenv.isDarwin [
            colima
          ];

          commands = lib.mkIf stdenv.isDarwin
            [
              {
                name = "start";
                help = "Start the colima virtual machine";
                command = "colima start";
                category = "commands";
              }
              {
                name = "stop";
                help = "Stop the colima virtual machine";
                command = "colima stop";
                category = "commands";
              }
            ];
                       
        };

      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
