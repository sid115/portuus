{
  writeShellScriptBin,
  symlinkJoin,
  ...
}:

let
  wrapped = writeShellScriptBin "rebuild" (builtins.readFile ./rebuild.sh);
in
symlinkJoin {
  name = "rebuild";
  paths = [
    wrapped
  ];
}
