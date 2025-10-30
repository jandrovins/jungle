{
  stdenv
, lib
, fetchurl
, symlinkJoin
, slurm
, rdma-core
, autoconf
, automake
, libtool
, mpi
, gfortran
}:

let
  rdma-core-all = symlinkJoin {
    name ="rdma-core-all";
    paths = [ rdma-core.dev rdma-core.out ];
  };
  mpiAll = symlinkJoin {
    name = "mpi-all";
    paths = [ mpi.all ];
  };
in

stdenv.mkDerivation rec {
  pname = "GPI-2";
  version = "tagaspi-2021.11";

  src = fetchurl {
    url = "https://pm.bsc.es/gitlab/interoperability/extern/GPI-2/-/archive/${version}/GPI-2-${version}.tar.gz";
    hash = "sha256-eY2wpyTpnOXRoAcYoAP82Jq9Q7p5WwDpMj+f1vEX5zw=";
  };

  enableParallelBuilding = true;

  patches = [ ./rdma-core.patch ./max-mem.patch ];

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  configureFlags = [
    "--with-infiniband=${rdma-core-all}"
    "--with-mpi=yes" # fixes mpi detection when cross-compiling
    "--with-slurm"
    "CFLAGS=-fPIC"
    "CXXFLAGS=-fPIC"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gfortran
    libtool
  ];

  buildInputs = [
    slurm
    mpiAll
    rdma-core-all
  ];

  hardeningDisable = [ "all" ];

  meta = {
    homepage = "https://pm.bsc.es/gitlab/interoperability/extern/GPI-2";
    description = "GPI-2 extended for supporting Task-Aware GASPI (TAGASPI) library";
    maintainers = with lib.maintainers.bsc; [ rarias ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    cross = false; # infiniband detection does not work
  };
}
