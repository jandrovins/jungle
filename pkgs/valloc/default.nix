{
  stdenv
, lib
, fetchFromGitHub
, numactl
, cmake
, nosv ? null
, gitUrl ? "https://github.com/jandrovins/valloc.git"
, gitBranch ? "main"
, gitCommit ? "7fb59c215e2e1e4a60bf93a4823f0e091030054d"
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
