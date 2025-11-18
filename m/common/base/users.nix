{ pkgs, ... }:

{
  imports = [
    ../../module/jungle-users.nix
  ];

  users = {
    mutableUsers = false;
    users = {
      # Generate hashedPassword with `mkpasswd -m sha-512`

      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBOf4r4lzQfyO0bx5BaREePREw8Zw5+xYgZhXwOZoBO ram@hop"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINa0tvnNgwkc5xOwd6xTtaIdFi5jv0j2FrE7jl5MTLoE ram@mio"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3zeB5KSimMBAjvzsp1GCkepVaquVZGPYwRIzyzaCba aleix@bsc"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIII/1TNArcwA6D47mgW4TArwlxQRpwmIGiZDysah40Gb root@hut"
      ];

      rarias = {
        uid = 1880;
        isNormalUser = true;
        linger = true;
        home = "/home/Computational/rarias";
        description = "Rodrigo Arias";
        group = "Computational";
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$u06tkCy13enReBsb$xiI.twRvvTfH4jdS3s68NZ7U9PSbGKs5.LXU/UgoawSwNWhZo2hRAjNL5qG0/lAckzcho2LjD0r3NfVPvthY6/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBOf4r4lzQfyO0bx5BaREePREw8Zw5+xYgZhXwOZoBO ram@hop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINa0tvnNgwkc5xOwd6xTtaIdFi5jv0j2FrE7jl5MTLoE ram@mio"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYcXIxe0poOEGLpk8NjiRozls7fMRX0N3j3Ar94U+Gl rarias@hal"
        ];
        shell = pkgs.zsh;
      };

      arocanon = {
        uid = 1042;
        isNormalUser = true;
        home = "/home/Computational/arocanon";
        description = "Aleix Roca";
        group = "Computational";
        extraGroups = [ "wheel" "tracing" ];
        hashedPassword = "$6$hliZiW4tULC/tH7p$pqZarwJkNZ7vS0G5llWQKx08UFG9DxDYgad7jplMD8WkZh5k58i4dfPoWtnEShfjTO6JHiIin05ny5lmSXzGM/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3zeB5KSimMBAjvzsp1GCkepVaquVZGPYwRIzyzaCba aleix@bsc"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGdphWxLAEekicZ/WBrvP7phMyxKSSuLAZBovNX+hZXQ aleix@kerneland"
        ];
      };
    };

    jungleUsers = {
      rpenacob = {
        uid = 2761;
        isNormalUser = true;
        home = "/home/Computational/rpenacob";
        description = "Raúl Peñacoba";
        group = "Computational";
        hosts = [ "apex" "owl1" "owl2" "hut" "tent" "fox" ];
        hashedPassword = "$6$TZm3bDIFyPrMhj1E$uEDXoYYd1z2Wd5mMPfh3DZAjP7ztVjJ4ezIcn82C0ImqafPA.AnTmcVftHEzLB3tbe2O4SxDyPSDEQgJ4GOtj/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFYfXg37mauGeurqsLpedgA2XQ9d4Nm0ZGo/hI1f7wwH rpenacob@bsc"
        ];
      };

      anavarro = {
        uid = 1037;
        isNormalUser = true;
        home = "/home/Computational/anavarro";
        description = "Antoni Navarro";
        group = "Computational";
        hosts = [ "apex" "hut" "tent" "raccoon" "fox" "weasel" ];
        hashedPassword = "$6$EgturvVYXlKgP43g$gTN78LLHIhaF8hsrCXD.O6mKnZSASWSJmCyndTX8QBWT6wTlUhcWVAKz65lFJPXjlJA4u7G1ydYQ0GG6Wk07b1";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMsbM21uepnJwPrRe6jYFz8zrZ6AYMtSEvvt4c9spmFP toni@delltoni"
        ];
      };

      abonerib = {
        uid = 4541;
        isNormalUser = true;
        home = "/home/Computational/abonerib";
        description = "Aleix Boné";
        group = "Computational";
        hosts = [ "apex" "owl1" "owl2" "hut" "tent" "raccoon" "fox" "weasel" ];
        hashedPassword = "$6$V1EQWJr474whv7XJ$OfJ0wueM2l.dgiJiiah0Tip9ITcJ7S7qDvtSycsiQ43QBFyP4lU0e0HaXWps85nqB4TypttYR4hNLoz3bz662/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIFiqXqt88VuUfyANkZyLJNiuroIITaGlOOTMhVDKjf abonerib@bsc"
        ];
      };

      vlopez = {
        uid = 4334;
        isNormalUser = true;
        home = "/home/Computational/vlopez";
        description = "Victor López";
        group = "Computational";
        hosts = [ "apex" "koro" ];
        hashedPassword = "$6$0ZBkgIYE/renVqtt$1uWlJsb0FEezRVNoETTzZMx4X2SvWiOsKvi0ppWCRqI66S6TqMBXBdP4fcQyvRRBt0e4Z7opZIvvITBsEtO0f0";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMwlUZRf9jfG666Qa5Sb+KtEhXqkiMlBV2su3x/dXHq victor@arch"
        ];
      };

      dbautist = {
        uid = 5649;
        isNormalUser = true;
        home = "/home/Computational/dbautist";
        description = "Dylan Bautista Cases";
        group = "Computational";
        hosts = [ "apex" "hut" "tent" "raccoon" ];
        hashedPassword = "$6$a2lpzMRVkG9nSgIm$12G6.ka0sFX1YimqJkBAjbvhRKZ.Hl090B27pdbnQOW0wzyxVWySWhyDDCILjQELky.HKYl9gqOeVXW49nW7q/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAb+EQBoS98zrCwnGKkHKwMLdYABMTqv7q9E0+T0QmkS dbautist@bsc-848818791"
        ];
      };

      dalvare1 = {
        uid = 2758;
        isNormalUser = true;
        home = "/home/Computational/dalvare1";
        description = "David Álvarez";
        group = "Computational";
        hosts = [ "apex" "hut" "tent" "fox" ];
        hashedPassword = "$6$mpyIsV3mdq.rK8$FvfZdRH5OcEkUt5PnIUijWyUYZvB1SgeqxpJ2p91TTe.3eQIDTcLEQ5rxeg.e5IEXAZHHQ/aMsR5kPEujEghx0";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEfy6F4rF80r4Cpo2H5xaWqhuUZzUsVsILSKGJzt5jF dalvare1@ssfhead"
        ];
      };

      varcila = {
        uid = 5650;
        isNormalUser = true;
        home = "/home/Computational/varcila";
        description = "Vincent Arcila";
        group = "Computational";
        hosts = [ "apex" "hut" "tent" "fox" ];
        hashedPassword = "$6$oB0Tcn99DcM4Ch$Vn1A0ulLTn/8B2oFPi9wWl/NOsJzaFAWjqekwcuC9sMC7cgxEVb.Nk5XSzQ2xzYcNe5MLtmzkVYnRS1CqP39Y0";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGt0ESYxekBiHJQowmKpfdouw0hVm3N7tUMtAaeLejK vincent@varch"
        ];
        shell = pkgs.zsh;
      };

      pmartin1 = {
        # Arbitrary UID but large so it doesn't collide with other users on ssfhead.
        uid = 9652;
        isNormalUser = true;
        home = "/home/Computational/pmartin1";
        description = "Pedro J. Martinez-Ferrer";
        group = "Computational";
        hosts = [ "fox" ];
        hashedPassword = "$6$nIgDMGnt4YIZl3G.$.JQ2jXLtDPRKsbsJfJAXdSvjDIzRrg7tNNjPkLPq3KJQhMjfDXRUvzagUHUU2TrE2hHM8/6uq8ex0UdxQ0ysl.";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIV5LEAII5rfe1hYqDYIIrhb1gOw7RcS1p2mhOTqG+zc pedro@pedro-ThinkPad-P14s-Gen-2a"
        ];
      };

      csiringo = {
        uid = 9653;
        isNormalUser = true;
        home = "/home/Computational/csiringo";
        description = "Cesare Siringo";
        group = "Computational";
        hosts = [ ];
        hashedPassword = "$6$0IsZlju8jFukLlAw$VKm0FUXbS.mVmPm3rcJeizTNU4IM5Nmmy21BvzFL.cQwvlGwFI1YWRQm6gsbd4nbg47mPDvYkr/ar0SlgF6GO1";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHA65zvvG50iuFEMf+guRwZB65jlGXfGLF4HO+THFaed csiringo@bsc.es"
        ];
      };

      acinca = {
        uid = 9654;
        isNormalUser = true;
        home = "/home/Computational/acinca";
        description = "Arnau Cinca";
        group = "Computational";
        hosts = [ "apex" "hut" "fox" "owl1" "owl2" ];
        hashedPassword = "$6$S6PUeRpdzYlidxzI$szyvWejQ4hEN76yBYhp1diVO5ew1FFg.cz4lKiXt2Idy4XdpifwrFTCIzLTs5dvYlR62m7ekA5MrhcVxR5F/q/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmMqKqPg4uocNOr3O41kLbZMOMJn3m2ZdN1JvTR96z3 bsccns@arnau-bsc"
        ];
      };

      aaguirre = {
        uid = 9655;
        isNormalUser = true;
        home = "/home/Computational/aaguirre";
        description = "Alejandro Aguirre";
        group = "Computational";
        hosts = [ "apex" "hut" ];
        hashedPassword = "$6$TXRXQT6jjBvxkxU6$E.sh5KspAm1qeG5Ct7OPHpo8REmbGDwjFGvqeGgTVz3GASGOAnPL7UMZsMAsAKBoahOw.v8LNno6XGrTEPzZH1";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlRX7ZCnqtUJYCxKgWmgSrFCYuA2LHY96rVwqxXPl86 aaguirre@BSC-8488184117"
        ];
      };
    };

    groups = {
      Computational = { gid = 564; };
      tracing = { };
    };
  };
}
