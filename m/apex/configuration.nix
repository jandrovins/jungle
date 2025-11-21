{ lib, config, pkgs, ... }:

{
  imports = [
    ../common/xeon.nix
    ../common/ssf/hosts.nix
    ../module/ceph.nix
    ../module/hut-substituter.nix
    ../module/slurm-server.nix
    ./nfs.nix
    ./wireguard.nix
  ];

  # Don't install grub MBR for now
  boot.loader.grub.device = "nodev";

  boot.initrd.kernelModules = [
    "megaraid_sas" # For HW RAID
  ];

  environment.systemPackages = with pkgs; [
    storcli # To manage HW RAID
  ];

  fileSystems."/home" = {
    device = "/dev/disk/by-label/home";
    fsType = "ext4";
  };

  # No swap, there is plenty of RAM
  swapDevices = lib.mkForce [];

  networking = {
    hostName = "apex";
    defaultGateway = "84.88.53.233";
    nameservers = [ "8.8.8.8" ];

    # Public facing interface
    interfaces.eno1.ipv4.addresses = [ {
      address = "84.88.53.236";
      prefixLength = 29;
    } ];

    # Internal LAN to our Ethernet switch
    interfaces.eno2.ipv4.addresses = [ {
      address = "10.0.40.30";
      prefixLength = 24;
    } ];

    # Infiniband over Omnipath switch (disconnected for now)
    # interfaces.ibp5s0 = {};

    nat = {
      enable = true;
      internalInterfaces = [ "eno2" ];
      externalInterface = "eno1";
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime-increment = {
      enable = true; # Double ban time on each attack
      maxtime = "7d"; # Ban up to a week
    };
  };

  # Disable SSH login with password, allow only keypair
  services.openssh.settings.PasswordAuthentication = false;

  networking.firewall = {
    extraCommands = ''
      # Blackhole BSC vulnerability scanner (OpenVAS) as it is spamming our
      # logs. Insert as first position so we also protect SSH.
      iptables -I nixos-fw 1 -p tcp -s 192.168.8.16 -j nixos-fw-refuse
      # Same with opsmonweb01.bsc.es which seems to be trying to access via SSH
      iptables -I nixos-fw 2 -p tcp -s 84.88.52.176 -j nixos-fw-refuse
    '';
  };
}
