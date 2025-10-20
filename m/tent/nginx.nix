{ theFlake, pkgs, ... }:
let
  website = pkgs.stdenv.mkDerivation {
    name = "jungle-web";
    src = pkgs.fetchgit {
      url = "https://jungle.bsc.es/git/rarias/jungle-website.git";
      rev = "52abaf4d71652a9ef77a0b098db14ca33bffff4c";
      hash = "sha256-/ul9GazbOrOkmlvSgDz/+2W+V+ir5725Y7mVLc3rb0M=";
    };
    buildInputs = [ pkgs.hugo ];
    buildPhase = ''
      rm -rf public/
      hugo
    '';
    installPhase = ''
      cp -r public $out
    '';
    # Don't mess doc/
    dontFixup = true;
  };
in
{
  networking.firewall.allowedTCPPorts = [ 80 ];
  services.nginx = {
    enable = true;
    virtualHosts."jungle.bsc.es" = {
      root = "${website}";
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
      ];
      extraConfig = ''
        set_real_ip_from 127.0.0.1;
        set_real_ip_from 84.88.52.107;
        real_ip_recursive on;
        real_ip_header X-Forwarded-For;

        location /git {
          rewrite ^/git$ / break;
          rewrite ^/git/(.*) /$1 break;
          proxy_pass http://127.0.0.1:3000;
          proxy_redirect http:// $scheme://;
        }
        location /cache {
          rewrite ^/cache/(.*) /$1 break;
          proxy_pass http://127.0.0.1:5000;
          proxy_redirect http:// $scheme://;
        }
        location /lists {
          proxy_pass http://127.0.0.1:8081;
          proxy_redirect http:// $scheme://;
        }
        location /grafana {
          proxy_pass http://127.0.0.1:2342;
          proxy_redirect http:// $scheme://;
          proxy_set_header Host $host;
          # Websockets
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
        }
        location ~ ^/~(.+?)(/.*)?$ {
          alias /vault/home/$1/public_html$2;
          index  index.html index.htm;
          autoindex on;
          absolute_redirect off;
        }
        location /p/ {
          alias /var/lib/p/;
        }
        location /pub/ {
          alias /vault/pub/;
        }
      '';
    };
  };
}
