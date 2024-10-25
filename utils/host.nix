# Function definition to define hosts
# Reads settings from ../hosts/${hostname}.nix file to generate nixosSystem object
{ lib, ... }:
rec {
  # mkHost reads from hosts/${hostname}.nix file and creates a nixos config
  # input variables define the compilation environment, the files are loaded accordingly.
  mkHost =
    hostname:
    let
      inherit (import ./user.nix { inherit lib; }) mkUser;
      inherit (import ./modules.nix { inherit lib; }) listModules';
      hostConfig =
        if lib.hasSuffix ".nix" hostname then
          (import hostname { inherit lib; })
        else
          (import ../hosts/${hostname}.nix { inherit lib; });
      wslDefault =
        { ... }:
        {
          wsl.enable = true;
          wsl.nativeSystemd = true;
        };
      homeDefault =
        { ... }:
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            extraSpecialArgs = {
              inherit hostConfig;
            };
          };
        };
      darwinDefault =
        {
          config,
          determinate,
          lib,
          pkgs,
          ...
        }:
        let
          determinate-nixd-pkg = pkgs.runCommand "determinate-nixd" { } ''
            	mkdir -p $out/bin
            	cp ${determinate} $out/bin/determinate-nixd
            	chmod +x $out/bin/determinate-nixd
            	$out/bin/determinate-nixd --help
          '';
        in
        {
          # https://github.com/DeterminateSystems/determinate/blob/main/flake.nix
          # Settings specified in Determinate Systems flake.
          # Have to copy paste because no flakehub.
          # This is the important bit - force services.nix-daemon.enable = false;
          services.nix-daemon.enable = lib.mkForce false;

          # nix settings
          nix = {
            useDaemon = lib.mkForce true;
            settings = {
              netrc-file = lib.mkForce "/nix/var/determinate/netrc";
              # Post build hook is included in the default nix.conf created by determinate.
              # Effects of post-build-hook are unclear.	
              # post-build-hook = lib.mkForce "/nix/var/determinate/post-build-hook.sh";
              # upgrade-nix-store-path-url = lib.mkForce "https://install.determinate.systems/nix-upgrade/stable/universal";
            };
          };

          # creating LaunchDaemons for nix-darwin
          system.activationScripts.nix-daemon = lib.mkForce {
            enable = false;
            text = "";
          };
          system.activationScripts.launchd.text = lib.mkBefore ''
            if test -e /Library/LaunchDaemons/org.nixos.nix-daemon.plist; then
              echo "Unloading org.nixos.nix-daemon"
              launchctl bootout system /Library/LaunchDaemons/org.nixos.nix-daemon.plist || true
              mv /Library/LaunchDaemons/org.nixos.nix-daemon.plist /Library/LaunchDaemons/.before-determinate-nixd.org.nixos.nix-daemon.plist.skip
            fi

            if test -e /Library/LaunchDaemons/org.nixos.darwin-store.plist; then
              echo "Unloading org.nixos.darwin-store"
              launchctl bootout system /Library/LaunchDaemons/org.nixos.darwin-store.plist || true
              mv /Library/LaunchDaemons/org.nixos.darwin-store.plist /Library/LaunchDaemons/.before-determinate-nixd.org.nixos.darwin-store.plist.skip
            fi

            install -d -m 755 -o root -g wheel /usr/local/bin
            cp ${determinate-nixd-pkg}/bin/determinate-nixd /usr/local/bin/.determinate-nixd.next
            chmod +x /usr/local/bin/.determinate-nixd.next
            mv /usr/local/bin/.determinate-nixd.next /usr/local/bin/determinate-nixd
          '';

          launchd.daemons.determinate-nixd-store.serviceConfig = {
            Label = "systems.determinate.nix-store";
            RunAtLoad = true;

            StandardErrorPath = lib.mkForce "/var/log/determinate-nix-init.log";
            StandardOutPath = lib.mkForce "/var/log/determinate-nix-init.log";

            ProgramArguments = lib.mkForce [
              "/usr/local/bin/determinate-nixd"
              "--nix-bin"
              "${config.nix.package}/bin"
              "init"
            ];
          };

          launchd.daemons.determinate-nixd.serviceConfig =
            let
              mkPreferable = lib.mkOverride 750;
            in
            {
              Label = "systems.determinate.nix-daemon";

              StandardErrorPath = lib.mkForce "/var/log/determinate-nix-daemon.log";
              StandardOutPath = lib.mkForce "/var/log/determinate-nix-daemon.log";

              ProgramArguments = lib.mkForce [
                "/usr/local/bin/determinate-nixd"
                "--nix-bin"
                "${config.nix.package}/bin"
                "daemon"
              ];

              Sockets = {
                "determinate-nixd.socket" = {
                  # We'd set `SockFamily = "Unix";`, but nix-darwin automatically sets it with SockPathName
                  SockPassive = true;
                  SockPathName = "/var/run/determinate-nixd.socket";
                };

                "nix-daemon.socket" = {
                  # We'd set `SockFamily = "Unix";`, but nix-darwin automatically sets it with SockPathName
                  SockPassive = true;
                  SockPathName = "/var/run/nix-daemon.socket";
                };
              };

              SoftResourceLimits = {
                NumberOfFiles = mkPreferable 1048576;
                NumberOfProcesses = mkPreferable 1048576;
                Stack = mkPreferable 67108864;
              };
              HardResourceLimits = {
                NumberOfFiles = mkPreferable 1048576;
                NumberOfProcesses = mkPreferable 1048576;
                Stack = mkPreferable 67108864;
              };
            };
        };

      wslConfig =
        inputs:
        inputs.nixpkgs.lib.nixosSystem {
          system = hostConfig.system;
          pkgs = import inputs.nixpkgs {
            system = hostConfig.system;
            config.allowUnfree = hostConfig.unfree;
          };
          specialArgs = {
            inherit hostConfig;
            upkgs = import inputs.unstable {
              system = hostConfig.system;
              config.allowUnfree = hostConfig.unfree;
            };
            home-manager = inputs.home-manager;
            hyprland = inputs.hyprland;
            nixos-wsl = inputs.nixos-wsl;
            darwin = inputs.darwin;
            isWSL = true;
            isDarwin = false;
            isNixos = false;
          };
          modules =
            [
              inputs.nixos-wsl.nixosModules.default
              wslDefault
              inputs.home-manager.nixosModules.home-manager
              homeDefault
              hostConfig.wslConfig
            ]
            ++ (lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users))
            ++ (listModules' (toString ../modules));
        };

      darwinConfig =
        inputs:
        inputs.darwin.lib.darwinSystem {
          system = hostConfig.system;
          pkgs = import inputs.nixpkgs {
            system = hostConfig.system;
            config.allowUnfree = hostConfig.unfree;
          };
          specialArgs = {
            inherit hostConfig;
            upkgs = import inputs.unstable {
              system = hostConfig.system;
              config.allowUnfree = hostConfig.unfree;
            };
            home-manager = inputs.home-manager;
            hyprland = inputs.hyprland;
            nixos-wsl = inputs.nixos-wsl;
            darwin = inputs.darwin;
            determinate = inputs."determinate-nixd-${hostConfig.system}";
            isWSL = false;
            isDarwin = true;
            isNixos = false;
          };
          modules =
            [
              darwinDefault
              inputs.home-manager.darwinModules.home-manager
              homeDefault
              hostConfig.darwinConfig
            ]
            ++ (lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users))
            ++ (listModules' (toString ../modules));
        };

      nixosConfig =
        inputs:
        inputs.nixpkgs.lib.nixosSystem {
          system = hostConfig.system;
          pkgs = import inputs.nixpkgs {
            system = hostConfig.system;
            config.allowUnfree = hostConfig.unfree;
          };
          specialArgs = {
            inherit hostConfig;
            upkgs = import inputs.unstable {
              system = hostConfig.system;
              config.allowUnfree = hostConfig.unfree;
            };
            home-manager = inputs.home-manager;
            hyprland = inputs.hyprland;
            nixos-wsl = inputs.nixos-wsl;
            darwin = inputs.darwin;
            isWSL = false;
            isDarwin = false;
            isNixos = true;
          };
          modules =
            [
              inputs.home-manager.nixosModules.home-manager
              homeDefault
              hostConfig.nixosConfig
            ]
            ++ (lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users))
            ++ (listModules' (toString ../modules));
        };
    in
    { }
    // (if hostConfig ? wsl && hostConfig.wsl then { wslConfig = wslConfig; } else { })
    // (if hostConfig ? darwin && hostConfig.darwin then { darwinConfig = darwinConfig; } else { })
    // (if hostConfig ? nixos && hostConfig.nixos then { nixosConfig = nixosConfig; } else { });

  mkHostNixos =
    inputs: acc: hostname: configs:
    acc
    // (if configs ? wslConfig then { "${hostname}-wsl" = (configs.wslConfig inputs); } else { })
    // (if configs ? nixosConfig then { "${hostname}" = (configs.nixosConfig inputs); } else { });

  mkHostDarwin =
    inputs: acc: hostname: configs:
    acc // (if configs ? darwinConfig then { "${hostname}" = (configs.darwinConfig inputs); } else { });
}
