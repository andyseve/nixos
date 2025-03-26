{ config, lib, ... }:
{
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
}
