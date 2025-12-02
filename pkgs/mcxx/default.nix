{
  stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, nanos6
, gperf
, python3
, gfortran
, pkg-config
, sqlite
, flex
, bison
, gcc
}:

stdenv.mkDerivation rec {
  pname = "mcxx";
  version = "2023.11";

  passthru = {
    CC = "mcc";
    CXX = "mcxx";
  };

  # mcxx doesn't use tags, so we pick the same version of the ompss2 release
  src = fetchFromGitHub {
    owner = "bsc-pm";
    repo = pname;
    rev = "github-release-${version}";
    hash = "sha256-GyBvyy/HD3t9rHSXAYZRMhn4o4Nm/HFfjuOS8J0LPu8=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    python3
    gfortran
    pkg-config
    gperf
    gcc
  ];

  buildInputs = [
    nanos6
    sqlite.dev
  ];

  patches = [ ./intel.patch ];

  preConfigure = ''
    export ICC=icc
    export ICPC=icpc
    export IFORT=ifort
  '';

  configureFlags = [
    "--enable-ompss-2"
    "--with-nanos6=${nanos6}"
# Fails with "memory exhausted" with bison 3.7.1
#    "--enable-bison-regeneration"
  ];

  meta = {
    broken = true;
    homepage = "https://github.com/bsc-pm/mcxx";
    description = "C/C++/Fortran source-to-source compilation infrastructure aimed at fast prototyping";
    maintainers = with lib.maintainers.bsc; [ rpenacob ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
}
