{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ../common/ssf.nix
    ../module/monitoring.nix
    ../module/hut-substituter.nix
  ];

  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d53563a";

  boot.kernel.sysctl = {
    "kernel.yama.ptrace_scope" = lib.mkForce "1";
  };

  environment.systemPackages = with pkgs; [
    ceph
  ];

  services.ceph = {
    enable = true;
    global = {
      fsid = "9c8d06e0-485f-4aaf-b16b-06d6daf1232b";
      monHost = "10.0.40.40";
      monInitialMembers = "bay";
      clusterNetwork = "10.0.40.40/24"; # Use Ethernet only
    };
    osd = {
      enable = true;
      # One daemon per NVME disk
      daemons = [ "4" "5" "6" "7" ];
      extraConfig = {
        "osd crush chooseleaf type" = "0";
        "osd journal size" = "10000";
        "osd pool default min size" = "2";
        "osd pool default pg num" = "200";
        "osd pool default pgp num" = "200";
        "osd pool default size" = "3";
      };
    };
  };

  networking = {
    hostName = "lake2";
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.42";
      prefixLength = 24;
    } ];
    interfaces.ibs785.ipv4.addresses = [ {
      address = "10.0.42.42";
      prefixLength = 24;
    } ];
    firewall = {
      extraCommands = ''
        # Accept all incoming TCP traffic from bay
        iptables -A nixos-fw -p tcp -s bay -j nixos-fw-accept
        # Accept monitoring requests from hut
        iptables -A nixos-fw -p tcp -s hut --dport 9002 -j nixos-fw-accept
        # Accept all Ceph traffic from the local network
        iptables -A nixos-fw -p tcp -s 10.0.40.0/24 -m multiport --dport 3300,6789,6800:7568 -j nixos-fw-accept
      '';
    };
  };

  # Missing service for volumes, see:
  # https://www.reddit.com/r/ceph/comments/14otjyo/comment/jrd69vt/
  systemd.services.ceph-volume = {
    enable = true;
    description = "Ceph Volume activation";
    unitConfig = {
      Type = "oneshot";
      After = "local-fs.target";
      Wants = "local-fs.target";
    };
    path = [ pkgs.ceph pkgs.util-linux pkgs.lvm2 pkgs.cryptsetup ];
    serviceConfig = {
      KillMode = "none";
      Environment = "CEPH_VOLUME_TIMEOUT=10000";
      ExecStart = "/bin/sh -c 'timeout $CEPH_VOLUME_TIMEOUT ${pkgs.ceph}/bin/ceph-volume lvm activate --all --no-systemd'";
      TimeoutSec = "0";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
