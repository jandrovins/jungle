{ config, pkgs, lib, ... }:

{
  imports = [
    ../common/xeon.nix
    ../common/ssf/hosts.nix
    ../module/emulation.nix
    ../module/debuginfod.nix
    ./monitoring.nix
    ./nginx.nix
    ./nix-serve.nix
    ./gitlab-runner.nix
    ./gitea.nix
    ../hut/public-inbox.nix
    ../hut/msmtp.nix
    ../module/p.nix
    ../module/vpn-dac.nix
    ../module/hut-substituter.nix
    ../module/tc1-board.nix
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d537675";

  networking = {
    hostName = "tent";
    interfaces.eno1.ipv4.addresses = [
      {
        address = "10.0.44.4";
        prefixLength = 24;
      }
    ];

    # Only BSC DNSs seem to be reachable from the office VLAN
    nameservers = [ "84.88.52.35" "84.88.52.36" ];
    search = [ "bsc.es" "ac.upc.edu" ];
    defaultGateway = "10.0.44.1";
    hosts = {
      "84.88.53.236" = [ "apex" ];
      "10.0.44.1" = [ "raccoon" ];
    };
  };

  services.p.enable = true;

  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 9002;
    listenAddress = "127.0.0.1";
  };

  boot.swraid = {
    enable = true;
    mdadmConf = ''
      DEVICE partitions
      ARRAY /dev/md0 metadata=1.2 UUID=496db1e2:056a92aa:a544543f:40db379d
      MAILADDR root
    '';
  };

  fileSystems."/vault" = {
    device = "/dev/disk/by-label/vault";
    fsType = "ext4";
  };

  # Make a /vault/$USER directory for each user.
  systemd.services.create-vault-dirs = let
    # Take only normal users in tent
    users = lib.filterAttrs (_: v: v.isNormalUser) config.users.users;
    commands = lib.concatLists (lib.mapAttrsToList
      (_: user: [
        "install -d -o ${user.name} -g ${user.group} -m 0711 /vault/home/${user.name}"
      ]) users);
    script = pkgs.writeShellScript "create-vault-dirs.sh" (lib.concatLines commands);
  in {
    enable = true;
    wants = [ "local-fs.target" ];
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = script;
  };

  # disable automatic garbage collector
  nix.gc.automatic = lib.mkForce false;
}
