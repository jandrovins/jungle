{ config, lib, ... }:
{
  # Robot user that can see the password to send mail from jungle-robot
  users.groups.mail-robot = {};

  age.secrets.jungleRobotPassword = {
    file = ../../secrets/jungle-robot-password.age;
    group = "mail-robot";
    mode = "440";
  };

  programs.msmtp = {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        tls_starttls = false;
        port = 465;
        host = "mail.bsc.es";
        user = "jungle-robot";
        passwordeval = "cat ${config.age.secrets.jungleRobotPassword.path}";
        from = "jungle-robot@bsc.es";
      };
    };
  };
}
