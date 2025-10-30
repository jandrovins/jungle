{
  stdenv
, lib
, fetchFromGitHub
, automake
, autoconf
, libtool
, autoreconfHook
, gpi-2
, boost
, numactl
, rdma-core
, gfortran
}:

stdenv.mkDerivation rec {
  pname = "tagaspi";
  enableParallelBuilding = true;
  separateDebugInfo = true;

  version = "2.0";
  src = fetchFromGitHub {
    owner = "bsc-pm";
    repo = "tagaspi";
    rev = "v${version}";
    hash = "sha256-RGG/Re2uM293HduZfGzKUWioDtwnSYYdfeG9pVrX9EM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    automake
    autoconf
    libtool
    gfortran
  ];

  buildInputs = [
    boost
    numactl
    rdma-core
  ];

  dontDisableStatic = true;

  configureFlags = [
    "--with-gaspi=${gpi-2}"
    "CFLAGS=-fPIC"
    "CXXFLAGS=-fPIC"
  ];

  hardeningDisable = [ "all" ];

  meta = {
    homepage = "https://github.com/bsc-pm/tagaspi";
    description = "Task-Aware GASPI";
    maintainers = with lib.maintainers.bsc; [ rarias ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
}
