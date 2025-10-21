{ config, pkgs, ... }:
{
  systemd.timers = {
    "ompss2-closing" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "ompss2-closing.service";
        OnCalendar = [ "*-03-15 07:00:00" "*-09-15 07:00:00"];
      };
    };
    "ompss2-freeze" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "ompss2-freeze.service";
        OnCalendar = [ "*-04-15 07:00:00" "*-10-15 07:00:00" ];
      };
    };
    "ompss2-release" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "ompss2-release.service";
        OnCalendar = [ "*-05-15 07:00:00" "*-11-15 07:00:00" ];
      };
    };
  };

  systemd.services =
  let
    closing = pkgs.writeText "closing.txt"
    ''
      Subject: OmpSs-2 release enters closing period

      Hi,

      You have one month to merge the remaining features for the next OmpSs-2
      release. Please, identify what needs to be merged and discuss it in the next
      OmpSs-2 meeting.

      Thanks!,
      Jungle robot
    '';
    freeze = pkgs.writeText "freeze.txt"
    ''
      Subject: OmpSs-2 release enters freeze period

      Hi,

      The period to introduce new features or breaking changes is over, only bug
      fixes are allowed now. During this time, please prepare the release notes
      to be included in the next OmpSs-2 release.

      Thanks!,
      Jungle robot
    '';
    release = pkgs.writeText "release.txt"
    ''
      Subject: OmpSs-2 release now

      Hi,

      The period to introduce bug fixes is now over. Please, proceed to do the
      OmpSs-2 release.

      Thanks!,
      Jungle robot
    '';
    mkServ = name: mail: {
      "ompss2-${name}" = {
        script = ''
          set -eu
          set -o pipefail
          cat ${mail} | ${config.security.wrapperDir}/sendmail star@bsc.es
        '';
        serviceConfig = {
          Type = "oneshot";
          DynamicUser = true;
          Group = "mail-robot";
        };
      };
    };
  in
    (mkServ "closing" closing) //
    (mkServ "freeze" freeze) //
    (mkServ "release" release);
}
