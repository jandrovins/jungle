{ config, pkgs, ... }:

{
  imports = [
    ../common/ssf.nix
    ../module/ceph.nix
    ../module/emulation.nix
    ../module/slurm-client.nix
    ../module/slurm-firewall.nix
    ../module/debuginfod.nix
    ../module/hut-substituter.nix
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d535629";

  networking = {
    hostName = "owl2";
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.2";
      prefixLength = 24;
    } ];
    # Watch out! The OmniPath device is not in the same place here:
    interfaces.ibs801.ipv4.addresses = [ {
      address = "10.0.42.2";
      prefixLength = 24;
    } ];
  };
}
