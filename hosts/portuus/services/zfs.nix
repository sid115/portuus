{ pkgs, ... }:

{
  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
    frequent = 0;
    hourly = 0;
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

  environment.systemPackages = with pkgs; [ lz4 ];
}
