{ config, ... }:

let
  fqdn = "jitsi.${config.networking.domain}";
in
{
  nixpkgs.config.permittedInsecurePackages = [
    "jitsi-meet-1.0.8043"
  ];

  services.jitsi-meet = {
    enable = true;
    hostName = fqdn;
    nginx.enable = true;
    # prosody.lockdown = true;
    # https://github.com/jitsi/jitsi-meet/blob/master/config.js
    config = {
      enableWelcomePage = false;
      prejoinPageEnabled = true;
      defaultLang = "en";
    };
    interfaceConfig = {
      SHOW_JITSI_WATERMARK = false;
      SHOW_WATERMARK_FOR_GUESTS = false;
    };
  };

  services.jitsi-videobridge.openFirewall = true;
}
