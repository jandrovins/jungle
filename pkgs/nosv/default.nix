{
  stdenv
, lib
, autoreconfHook
, fetchFromGitHub
, pkg-config
, numactl
, hwloc
, papi
, enablePapi ? stdenv.hostPlatform == stdenv.buildPlatform # Disabled when cross-compiling
, cacheline ? 64 # bits
, ovni ? null
, useGit ? false
, gitUrl ? "git@gitlab-internal.bsc.es:nos-v/nos-v.git"
, gitBranch ? "master"
, gitCommit ? "1108e4786b58e0feb9a16fa093010b763eb2f8e8" # version 4.0.0
}:

with lib;

let
  release = rec {
    version = "4.0.0";
    src = fetchFromGitHub {
      owner = "bsc-pm";
      repo = "nos-v";
      rev = "${version}";
      hash = "sha256-llaq73bd/YxLVKNlMebnUHKa4z3sdcsuDUoVwUxNuw8=";
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
    pname = "nosv";
    inherit (source) src version;
    hardeningDisable = [ "all" ];
    dontStrip = true;
    separateDebugInfo = true;
    configureFlags = [
      "--with-ovni=${ovni}"
      "CACHELINE_WIDTH=${toString cacheline}"
    ];
    nativeBuildInputs = [
      autoreconfHook
      pkg-config
    ];
    buildInputs = [
      numactl
      hwloc
      ovni
    ] ++ lib.optionals enablePapi [ papi ];

    meta = {
      homepage = "https://gitlab.bsc.es/nos-v/nos-v";
      description = "Tasking library enables the co-execution of multiple applications with system-wide scheduling and a centralized management of resources";
      maintainers = with lib.maintainers.bsc; [ abonerib rarias ];
      platforms = lib.platforms.linux;
      license = lib.licenses.gpl3Plus;
    };
  }
