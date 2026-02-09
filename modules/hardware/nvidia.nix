{
  lib,
  pkgs,
  hostConfig,
  isDarwin,
  isWSL,
  ...
}:
let
  nvidiaEnabled =
    hostConfig ? hardware
    && hostConfig.hardware ? nvidia
    && (hostConfig.hardware.nvidia.enable or false);
in
lib.optionalAttrs (!isDarwin) {
  config = lib.mkMerge [
    (lib.mkIf nvidiaEnabled {
      environment.systemPackages = [
        pkgs.cudaPackages.cudatoolkit
        pkgs.cudaPackages.cudnn
      ];
    })
    (lib.mkIf (isWSL && nvidiaEnabled) {
      # Allow running WSL-provided dynamically linked NVIDIA tools like nvidia-smi.
      programs.nix-ld = {
        enable = true;
        libraries = [
          pkgs.stdenv.cc.cc.lib
        ];
      };

      # WSL-specific NVIDIA env to make CUDA tools happier.
      environment.sessionVariables = {
        CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
        EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
        EXTRA_CCFLAGS = "-I/usr/include";
        LD_LIBRARY_PATH = lib.concatStringsSep ":" [
          "/usr/lib/wsl/lib"
          "${pkgs.linuxPackages.nvidia_x11}/lib"
          "${pkgs.ncurses5}/lib"
        ];
        MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia";
        # Ensure nix-ld can see WSL GPU driver libs.
        NIX_LD_LIBRARY_PATH = lib.mkForce "/run/current-system/sw/share/nix-ld/lib:/usr/lib/wsl/lib";
      };
    })
  ];
}
