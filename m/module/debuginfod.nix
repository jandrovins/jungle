{
  services.nixseparatedebuginfod2 = {
    enable = true;
    substituters = [
      "local:"
      "https://cache.nixos.org"
      "http://hut/cache"
    ];
  };
}
