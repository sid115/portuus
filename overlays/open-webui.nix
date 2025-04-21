final: prev:

{
  open-webui = prev.open-webui.overrideAttrs (oldAttrs: rec {
    version = "0.6.4";
    src = prev.fetchFromGitHub {
      owner = "open-webui";
      repo = "open-webui";
      tag = "v${version}";
      hash = "sha256-tk0huzEe33pRm3o0t/AkWZyv82vNc1HQ0p5bRWmuNUc=";
    };
  });
}
