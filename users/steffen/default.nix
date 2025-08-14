{
  normalUsers.steffen = {
    extraGroups = [
      "wheel"
      "jellyfin"
    ];
    sshKeyFiles = [
      ./pubkeys/L13G2.pub
      ./pubkeys/X670E.pub
    ];
  };
}
