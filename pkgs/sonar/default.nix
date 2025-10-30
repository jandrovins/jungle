{
  stdenv
, lib
, autoreconfHook
, fetchFromGitHub
, ovni
, mpi
}:

stdenv.mkDerivation rec {
  pname = "sonar";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "bsc-pm";
    repo = "sonar";
    rev = "${version}";
    sha256 = "sha256-DazOEaiMfJLrZNtmQEEHdBkm/m4hq5e0mPEfMtzYqWk=";
  };
  hardeningDisable = [ "all" ];
  dontStrip = true;
  configureFlags = [ "--with-ovni=${ovni}" ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    ovni
    mpi
  ];

  meta = {
    homepage = "https://github.com/bsc-pm/sonar";
    description = "Set of runtime libraries which instrument parallel programming models through the ovni instrumentation library";
    maintainers = with lib.maintainers.bsc; [ rarias ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    cross = true;
  };
}
