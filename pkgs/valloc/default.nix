{
  stdenv
, lib
, fetchFromGitHub
, numactl
, cmake
, nosv ? null
, gitUrl ? "git@github.com:jandrovins/valloc.git"
, gitBranch ? "main"
, gitCommit ? "442764195b5dfabc0e46498f5bc286b1a9f8b753"
}:

with lib;

let
  git = rec {
    version = src.shortRev;
    src = builtins.fetchGit {
      url = gitUrl;
      ref = gitBranch;
      rev = gitCommit;
    };
  };

  source = git;
in
  stdenv.mkDerivation rec {
    pname = "valloc";
    inherit (source) src version;
    hardeningDisable = [ "all" ];
    dontStrip = true;
    separateDebugInfo = true;
    
    nativeBuildInputs = [
      cmake
      numactl.dev
    ];
    
    buildInputs = [
      numactl
    ];
  }
