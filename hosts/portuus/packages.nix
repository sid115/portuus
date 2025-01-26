{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    nvtopPackages.full
  ];
}
