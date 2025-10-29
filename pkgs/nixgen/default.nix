{
  stdenv
, lib
}:

stdenv.mkDerivation {
  pname = "nixgen";
  version = "0.0.1";
  src = ./nixgen;
  dontUnpack = true;
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp -a $src $out/bin/nixgen
  '';
  meta = {
    description = "Quickly generate flake.nix from command line";
    maintainers = with lib.maintainers.bsc; [ rarias ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
}
