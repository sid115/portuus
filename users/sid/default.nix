{
  normalUsers.sid = {
    extraGroups = [
      "wheel"
      "jellyfin"
      "adbusers"
      "kvm"
    ];
    sshKeyFiles = [ ./pubkeys/gpg.pub ];
  };
}
