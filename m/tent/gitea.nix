{ config, lib, ... }:
{
  services.gitea = {
    enable = true;
    appName = "Gitea in the jungle";

    settings = {
      server = {
        ROOT_URL = "https://jungle.bsc.es/git/";
        LOCAL_ROOT_URL = "https://jungle.bsc.es/git/";
        LANDING_PAGE = "explore";
      };
      metrics.ENABLED = true;
      service = {
        DISABLE_REGISTRATION = true;
        REGISTER_MANUAL_CONFIRM = true;
        ENABLE_NOTIFY_MAIL = true;
      };
      log.LEVEL = "Warn";

      mailer = {
        ENABLED       = true;
        FROM          = "jungle-robot@bsc.es";
        PROTOCOL      = "sendmail";
        SENDMAIL_PATH = "/run/wrappers/bin/sendmail";
        SENDMAIL_ARGS = "--";
      };
    };
  };

  # Allow gitea user to send mail
  users.users.gitea.extraGroups = [ "mail-robot" ];
}
