{
  stdenv
, lib
, fetchFromGitHub
, pkg-config
, cmake
, clangOmpss2
, numactl
, nosv ? null
, gitUrl ? "git@github.com:jandrovins/tglib.git"
, gitBranch ? "main"
, gitCommit ? "d78d0a4463385344e07ef265881a670ceda04823"
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
    pname = "tglib";
    inherit (source) src version;
    hardeningDisable = [ "all" ];
    dontStrip = true;
    separateDebugInfo = true;
    
    preBuild = ''
      export NOSV_HOME=${nosv}
    '';
    
    nativeBuildInputs = [
      pkg-config
      cmake
      clangOmpss2
      nosv
      numactl.dev
    ];
    
    buildInputs = [
      nosv
      numactl
    ];
    
    cmakeFlags = [
      "-DCMAKE_C_COMPILER=${clangOmpss2}/bin/clang"
      "-DCMAKE_CXX_COMPILER=${clangOmpss2}/bin/clang++"
    ];
  }
