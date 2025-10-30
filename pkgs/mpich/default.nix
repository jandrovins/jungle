{
  stdenv
, lib
, libfabric
, mpich
, pmix
, gfortran
, symlinkJoin
# Disabled when cross-compiling
# To fix cross compilation, we should fill the values in:
# https://github.com/pmodels/mpich/blob/main/maint/fcrosscompile/cross_values.txt.in
# For each arch
, enableFortran ? stdenv.hostPlatform == stdenv.buildPlatform
, perl
}:

let
  # pmix comes with the libraries in .out and headers in .dev
  pmixAll = symlinkJoin {
    name = "pmix-all";
    paths = [ pmix.dev pmix.out ];
  };
in mpich.overrideAttrs (old: {
  buildInputs = old.buildInputs ++ [
    libfabric
    pmixAll
  ];
  nativeBuildInputs = old.nativeBuildInputs ++ [
    perl
  ];
  configureFlags = [
    "--enable-shared"
    "--enable-sharedlib"
    "--with-pm=no"
    "--with-device=ch4:ofi"
    "--with-pmi=pmix"
    "--with-pmix=${pmixAll}"
    "--with-libfabric=${libfabric}"
    "--enable-g=log"
  ] ++ lib.optionals (lib.versionAtLeast gfortran.version "10") [
    "FFLAGS=-fallow-argument-mismatch" # https://github.com/pmodels/mpich/issues/4300
    "FCFLAGS=-fallow-argument-mismatch"
  ] ++ lib.optionals (!enableFortran) [
    "--disable-fortran"
  ];

  preFixup = ''
    sed -i 's:^CC=.*:CC=gcc:' $out/bin/mpicc
    sed -i 's:^CXX=.*:CXX=g++:' $out/bin/mpicxx
  '' + lib.optionalString enableFortran ''
    sed -i 's:^FC=.*:FC=gfortran:' $out/bin/mpifort
  '';

  hardeningDisable = [ "all" ];

  meta = old.meta // {
    maintainers = old.meta.maintainers ++ (with lib.maintainers.bsc; [ rarias ]);
    cross = true;
  };
})
