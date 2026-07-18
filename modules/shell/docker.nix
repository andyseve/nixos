{
  isDarwin,
  hostConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = hostConfig.shell or { };
in
lib.optionalAttrs (!isDarwin) {
  config = mkIf (cfg.docker.enable or false) {
    virtualisation.docker = {
      enable = true;
      package = pkgs.docker_29;
    };
    environment.systemPackages = [
      pkgs.docker-compose
    ];
  };
}
