{ config, lib, ... }:
{
  age.secrets.giteaRunnerToken.file = ../../secrets/gitea-runner-token.age;

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

  services.gitea-actions-runner.instances = {
    runrun = {
      enable = true;
      name = "runrun";
      url = "https://jungle.bsc.es/git/";
      tokenFile = config.age.secrets.giteaRunnerToken.path;
      labels = [ "native:host" ];
      settings.runner.capacity = 8;
    };
  };

  systemd.services.gitea-runner-runrun = {
    path = [ "/run/current-system/sw" ];
    serviceConfig = {
      # DynamicUser doesn't work well with SSH
      DynamicUser = lib.mkForce false;
      User = "gitea-runner";
      Group = "gitea-runner";
    };
  };

  users.users.gitea-runner = {
    isSystemUser = true;
    home = "/var/lib/gitea-runner";
    description = "Gitea Runner";
    group = "gitea-runner";
    extraGroups = [ "docker" ];
    createHome = true;
  };
  users.groups.gitea-runner = {};
}

