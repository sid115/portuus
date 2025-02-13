{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    core.marker-pdf
    intel-gpu-tools
    nvtopPackages.full
  ];
}
