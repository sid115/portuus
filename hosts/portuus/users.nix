{ inputs, ... }:

{
  imports = [
    inputs.core.nixosModules.normalUsers

    ../../users/pascal
    ../../users/sid
    ../../users/steffen
    ../../users/ulm
  ];
}
