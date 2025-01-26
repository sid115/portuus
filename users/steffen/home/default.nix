{ inputs, outputs, ... }:

{
  imports = [
    inputs.core.homeModules.common
    inputs.core.homeModules.nixvim

    outputs.homeModules.common
  ];

  home.username = "steffen";

  programs.git = {
    enable = true;
    userName = "steffen";
    userEmail = "steffen@portuus.de";
  };

  programs.nixvim.enable = true;

  home.stateVersion = "24.11";
}
