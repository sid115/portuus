{ config, ... }:

# Setup:
# sudo -u hydra hydra-create-user sid --full-name sid --email-address 'sid@portuus.de' --password-prompt --role admin

let
  cfg = config.services.hydra;
in
{
  services.hydra = {
    enable = true;
    port = 3344;
    hydraURL = "hydra.${config.networking.domain}";
    # buildMachinesFiles = [ "/etc/nix/machines" ];
    useSubstitutes = true;

    notificationSender = "hydra@${config.networking.domain}";
    smtpHost = config.mailserver.fqdn;
  };

  # put this in the aarch64 vm:
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  nix.settings.allowed-uris = [
    "github:"
    "git+https://github.com/"
    "git+ssh://github.com/"
  ];

  services.nginx.virtualHosts."${cfg.hydraURL}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:${toString cfg.port}";
  };

  mailserver.loginAccounts = {
    "${cfg.notificationSender}" = {
      hashedPasswordFile = config.sops.secrets."hydra/hashed-smtp-password".path;
    };
  };

  sops =
    let
      owner = "hydra";
      group = "hydra";
      mode = "0440";
    in
    {
      secrets."hydra/smtp-password" = {
        inherit owner group mode;
      };
      secrets."hydra/hashed-smtp-password" = {
        inherit owner group mode;
      };
    };
}
