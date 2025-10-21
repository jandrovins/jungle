{ config, pkgs, lib, ... }:

{
  imports = [
    ../common/ssf.nix

    ../module/ceph.nix
    ../module/debuginfod.nix
    ../module/emulation.nix
    ./gitlab-runner.nix
    ./monitoring.nix
    ./nfs.nix
    ./nix-serve.nix
    ./public-inbox.nix
    ./gitea.nix
    ./msmtp.nix
    ./postgresql.nix
    ./nginx.nix
    ./p.nix
    ./ompss2-timer.nix
    #./pxe.nix
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d53567f";

  fileSystems = {
    "/" = lib.mkForce {
      device = "/dev/disk/by-label/nvme";
      fsType = "ext4";
      neededForBoot = true;
      options = [ "noatime" ];
    };

    "/boot" = lib.mkForce {
      device = "/dev/disk/by-label/nixos-boot";
      fsType = "ext4";
      neededForBoot = true;
    };
  };

  networking = {
    hostName = "hut";
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.7";
      prefixLength = 24;
    } ];
    interfaces.ibp5s0.ipv4.addresses = [ {
      address = "10.0.42.7";
      prefixLength = 24;
    } ];
    firewall = {
      extraCommands = ''
        # Accept all proxy traffic from compute nodes but not the login
        iptables -A nixos-fw -p tcp -s 10.0.40.30 --dport 23080 -j nixos-fw-log-refuse
        iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 23080 -j nixos-fw-accept
      '';
      # Flush all rules and chains on stop so it won't break on start
      extraStopCommands = ''
        iptables -F
        iptables -X
      '';
    };
  };

  # Allow proxy to bind to the ethernet interface
  services.openssh.settings.GatewayPorts = "clientspecified";
}
