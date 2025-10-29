{
  stdenv
, lib
, cmake
, mpi
, fetchFromGitHub
, useGit ? false
, gitBranch ? "master"
, gitUrl ? "ssh://git@bscpm04.bsc.es/rarias/ovni.git"
, gitCommit ? "06432668f346c8bdc1006fabc23e94ccb81b0d8b" # version 1.13.0
, enableDebug ? false
# Only enable MPI if the build is native (fails on cross-compilation)
, useMpi ? (stdenv.buildPlatform.canExecute stdenv.hostPlatform)
}:

let
  release = rec {
    version = "1.13.0";
    src = fetchFromGitHub {
      owner = "bsc-pm";
      repo = "ovni";
      rev = "${version}";
      hash = "sha256-0l2ryIyWNiZqeYdVlnj/WnQGS3xFCY4ICG8JedX424w=";
    } // { shortRev = "0643266"; };
  };

  git = rec {
    version = src.shortRev;
    src = builtins.fetchGit {
      url = gitUrl;
      ref = gitBranch;
      rev = gitCommit;
    };
  };

  source = if (useGit) then git else release;
in
  stdenv.mkDerivation rec {
    pname = "ovni";
    inherit (source) src version;
    dontStrip = true;
    separateDebugInfo = true;
    postPatch = ''
      patchShebangs --build test/
    '';
    nativeBuildInputs = [ cmake ] ++ lib.optionals (useMpi) [ mpi ];
    buildInputs = lib.optionals (useMpi) [ mpi ];
    cmakeBuildType = if (enableDebug) then "Debug" else "Release";
    cmakeFlags = [
      "-DOVNI_GIT_COMMIT=${src.shortRev}"
    ] ++ lib.optionals (!useMpi) [ "-DUSE_MPI=OFF" ];
    preCheck = ''
      export CTEST_OUTPUT_ON_FAILURE=1
    '';
    doCheck = true;
    checkTarget = "test";
    hardeningDisable = [ "all" ];

    meta = {
      homepage = "https://ovni.readthedocs.io";
      description = "Obtuse but Versatile Nanoscale Instrumentation";
      maintainers = with lib.maintainers.bsc; [ rarias ];
      platforms = lib.platforms.linux;
      license = lib.licenses.gpl3Plus;
      cross = true;
    };
  }
