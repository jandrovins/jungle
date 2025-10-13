{ pkgs, ... }:

{
  imports = [ ../../module/agenix.nix ];

  # Add agenix to system packages
  environment.systemPackages = [ pkgs.agenix ];
}
