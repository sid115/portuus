{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # core.marker-pdf # FIXME
    intel-gpu-tools
    nvtopPackages.full
  ];
}
