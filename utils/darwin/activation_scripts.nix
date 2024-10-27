{ config, determinate, lib, pkgs, ... }: let
          determinate-nixd-pkg = pkgs.runCommand "determinate-nixd" { } ''
            	mkdir -p $out/bin
            	cp ${determinate} $out/bin/determinate-nixd
            	chmod +x $out/bin/determinate-nixd
            	$out/bin/determinate-nixd --help
          '';
in {
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

	  system.activationScripts.extraActivation.text = lib.mkAfter ''
	  	softwareupdate --install-rosetta --agree-to-license
		xcode-select --install
	  '';
}
