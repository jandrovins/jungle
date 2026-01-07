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
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d53566c";

  networking = {
    hostName = "owl1";
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.1";
      prefixLength = 24;
    } ];
    interfaces.ibs785.ipv4.addresses = [ {
      address = "10.0.42.1";
      prefixLength = 24;
    } ];
  };
}
