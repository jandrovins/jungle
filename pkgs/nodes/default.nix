{
  stdenv
, lib
, fetchFromGitHub
, pkg-config
, numactl
, hwloc
, boost
, autoreconfHook
, ovni
, nosv
, clangOmpss2
, which
, useGit ? false
, gitUrl ? "ssh://git@gitlab-internal.bsc.es/nos-v/nodes.git"
, gitBranch ? "master"
, gitCommit ? "511489e71504a44381e0930562e7ac80ac69a848" # version-1.4
}:

with lib;

let
  release = rec {
    version = "1.4";
    src = fetchFromGitHub {
      owner = "bsc-pm";
      repo = "nodes";
      rev = "version-${version}";
      hash = "sha256-+lR/R0l3fGZO3XG7whMorFW2y2YZ0ZFnLeOHyQYrAsQ=";
    };
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
    pname = "nodes";
    inherit (source) src version;

    enableParallelBuilding = true;
    dontStrip = true;
    separateDebugInfo = true;

    configureFlags = [
      "--with-nosv=${nosv}"
      "--with-ovni=${ovni}"
    ] ++ lib.optionals doCheck [
      "--with-nodes-clang=${clangOmpss2}"
    ];

    doCheck = false;
    nativeCheckInputs = [
      clangOmpss2
      which
    ];

    # The "bindnow" flags are incompatible with ifunc resolution mechanism. We
    # disable all by default, which includes bindnow.
    hardeningDisable = [ "all" ];

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
    ];

    buildInputs = [
      boost
      numactl
      hwloc
      nosv
      ovni
    ];

    passthru = {
      inherit nosv;
    };

    meta = {
      homepage = "https://gitlab.bsc.es/nos-v/nodes";
      description = "Runtime library designed to work on top of the nOS-V runtime";
      maintainers = with lib.maintainers.bsc; [ abonerib rarias ];
      platforms = lib.platforms.linux;
      license = lib.licenses.gpl3Plus;
    };
  }
