# SPDX-License-Identifier: MIT
{
  pkgs,
  inputs,
  ...
}:
{
  dev-udev-rules = pkgs.callPackage ./dev-udev-rules {};
}
// pkgs.lib.optionalAttrs (pkgs.system == "x86_64-linux") {
}
