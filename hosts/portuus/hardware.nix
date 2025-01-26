{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "rpool/root";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/nix";
    fsType = "zfs";
  };

  fileSystems."/tmp" = {
    device = "rpool/tmp";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "rpool/var";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT1";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/data" = {
    device = "dpool/data";
    fsType = "zfs";
  };

  fileSystems."/data/firefly-iii" = {
    device = "dpool/data/firefly-iii";
    fsType = "zfs";
  };

  fileSystems."/data/gitea" = {
    device = "dpool/data/gitea";
    fsType = "zfs";
  };

  fileSystems."/data/jellyfin" = {
    device = "dpool/data/jellyfin";
    fsType = "zfs";
  };

  fileSystems."/data/jirafeau" = {
    device = "dpool/data/jirafeau";
    fsType = "zfs";
  };

  fileSystems."/data/matrix-synapse" = {
    device = "dpool/data/matrix-synapse";
    fsType = "zfs";
  };

  fileSystems."/data/nextcloud" = {
    device = "dpool/data/nextcloud";
    fsType = "zfs";
  };

  fileSystems."/data/peertube" = {
    device = "dpool/data/peertube";
    fsType = "zfs";
  };

  fileSystems."/data/rss-bridge" = {
    device = "dpool/data/rss-bridge";
    fsType = "zfs";
  };

  fileSystems."/data/syncthing" = {
    device = "dpool/data/syncthing";
    fsType = "zfs";
  };

  fileSystems."/data/tt-rss" = {
    device = "dpool/data/tt-rss";
    fsType = "zfs";
  };

  swapDevices = [
    { device = "/dev/disk/by-label/SWAP1"; }
    { device = "/dev/disk/by-label/SWAP2"; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
