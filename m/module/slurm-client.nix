{ lib, pkgs, ... }:

{
  imports = [
    ./slurm-common.nix
  ];

  systemd.services.slurmd.serviceConfig = {
    # Kill all processes in the control group on stop/restart. This will kill
    # all the jobs running, so ensure that we only upgrade when the nodes are
    # not in use. See:
    # https://github.com/NixOS/nixpkgs/commit/ae93ed0f0d4e7be0a286d1fca86446318c0c6ffb
    # https://bugs.schedmd.com/show_bug.cgi?id=2095#c24
    KillMode = lib.mkForce "control-group";

    # If slurmd fails to contact the control server it will fail, causing the
    # node to remain out of service until manually restarted. Always try to
    # restart it.
    Restart = "always";
    RestartSec = "30s";
  };

  services.slurm.client.enable = true;

  # Only allow SSH connections from users who have a SLURM allocation
  # See: https://slurm.schedmd.com/pam_slurm_adopt.html
  security.pam.services.sshd.rules.account.slurm = {
    control = "required";
    enable = true;
    modulePath = "${pkgs.slurm}/lib/security/pam_slurm_adopt.so";
    args = [ "log_level=debug5" ];
    order = 999999; # Make it last one
  };

  # Disable systemd session (pam_systemd.so) as it will conflict with the
  # pam_slurm_adopt.so module. What happens is that the shell is first adopted
  # into the slurmstepd task and then into the systemd session, which is not
  # what we want, otherwise it will linger even if all jobs are gone.
  security.pam.services.sshd.startSession = lib.mkForce false;
}
