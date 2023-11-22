# user settings
{
  config,
  pkgs,
  ...
}: {
  users.users.stranger = {
    isNormalUser = true;
    home = "/home/stranger";
    description = "Anish Sevekari";
    extraGroups = [ "wheel" "networkmanager" "video" ]; # Enable ‘sudo’ for the user.
    createHome = true;
    shell = "${pkgs.zsh}/bin/zsh";
  };
}
