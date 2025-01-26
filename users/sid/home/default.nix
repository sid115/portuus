{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    inputs.core.homeModules.common
    inputs.core.homeModules.nixvim

    outputs.homeModules.common
  ];

  home.username = "sid";

  programs.git = {
    enable = true;
    userName = "sid";
    userEmail = "sid@portuus.de";
  };

  programs.nixvim.enable = true;

  # xdg might not be available, hence `home.file`
  home.file.nixpkgs_config = {
    target = ".config/nixpkgs/config.nix";
    text = ''
      { allowUnfree = true; }
    '';
  };

  home.stateVersion = "24.11";
}
