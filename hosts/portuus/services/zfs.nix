{ pkgs, ... }:

# Mark datasets to snapshot
# sudo zfs set com.sun:auto-snapshot:daily=true dpool/data/backup

{
  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
    frequent = 0;
    hourly = 24;
    daily = 7;
    weekly = 4;
    monthly = 12;
  };

  services.zfs.autoReplication = {
    enable = true;
    host = "91.98.86.229";
    username = "root";
    # sudo -i ssh-keygen -t rsa -b 4096 -f /root/.ssh/zfs-replication
    identityFilePath = "/root/.ssh/zfs-replication";
    localFilesystem = "dpool/data/backup";
    remoteFilesystem = "dpool/portuus-backup";
    followDelete = true;
  };

  services.zfs.zed = {
    enableMail = true;
    settings = {
      ZED_EMAIL_ADDR = "postmaster@portuus.de";
      ZED_EMAIL_PROG = "sendmail";
      ZED_EMAIL_OPTS = "-t -f root@localhost";
      ZED_NOTIFY_VERBOSE = "1";
      ZED_NOTIFY_DATA = "1";
      ZED_NOTIFY_ERROR = "1";
      ZED_NOTIFY_WARNING = "1";
    };
  };

  environment.systemPackages = with pkgs; [ lz4 ];
}
