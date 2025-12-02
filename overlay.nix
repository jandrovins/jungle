final: /* Future last stage */
prev:  /* Previous stage */

with final.lib;

let
  callPackage = final.callPackage;

  bscPkgs = {
    agenix = prev.callPackage ./pkgs/agenix/default.nix { };
    amd-uprof = prev.callPackage ./pkgs/amd-uprof/default.nix { };
    bench6 = callPackage ./pkgs/bench6/default.nix { };
    bigotes = callPackage ./pkgs/bigotes/default.nix { };
    clangOmpss2 = callPackage ./pkgs/llvm-ompss2/default.nix { };
    clangOmpss2Nanos6 = callPackage ./pkgs/llvm-ompss2/default.nix { ompss2rt = final.nanos6; };
    clangOmpss2Nodes = callPackage ./pkgs/llvm-ompss2/default.nix { ompss2rt = final.nodes; openmp = final.openmp; };
    clangOmpss2NodesOmpv = callPackage ./pkgs/llvm-ompss2/default.nix { ompss2rt = final.nodes; openmp = final.openmpv; };
    clangOmpss2Unwrapped = callPackage ./pkgs/llvm-ompss2/clang.nix { };
    cudainfo = prev.callPackage ./pkgs/cudainfo/default.nix { };
    #extrae = callPackage ./pkgs/extrae/default.nix { }; # Broken and outdated
    gpi-2 = callPackage ./pkgs/gpi-2/default.nix { };
    intelPackages_2023 = callPackage ./pkgs/intel-oneapi/2023.nix { };
    jemallocNanos6 = callPackage ./pkgs/nanos6/jemalloc.nix { };
    # FIXME: Extend this to all linuxPackages variants. Open problem, see:
    # https://discourse.nixos.org/t/whats-the-right-way-to-make-a-custom-kernel-module-available/4636
    linuxPackages = prev.linuxPackages.extend (_final: _prev: {
      amd-uprof-driver = _prev.callPackage ./pkgs/amd-uprof/driver.nix { };
    });
    linuxPackages_latest = prev.linuxPackages_latest.extend(_final: _prev: {
      amd-uprof-driver = _prev.callPackage ./pkgs/amd-uprof/driver.nix { };
    });
    lmbench = callPackage ./pkgs/lmbench/default.nix { };
    # Broken and unmantained
    # mcxx = callPackage ./pkgs/mcxx/default.nix { };
    meteocat-exporter = prev.callPackage ./pkgs/meteocat-exporter/default.nix { };
    mpi = final.mpich; # Set MPICH as default
    mpich = callPackage ./pkgs/mpich/default.nix { mpich = prev.mpich; };
    nanos6 = callPackage ./pkgs/nanos6/default.nix { };
    nanos6Debug = final.nanos6.override { enableDebug = true; };
    nixtools = callPackage ./pkgs/nixtools/default.nix { };
    nixgen = callPackage ./pkgs/nixgen/default.nix { };
    # Broken because of pkgsStatic.libcap
    # See: https://github.com/NixOS/nixpkgs/pull/268791
    #nix-wrap = callPackage ./pkgs/nix-wrap/default.nix { };
    nodes = callPackage ./pkgs/nodes/default.nix { };
    nosv = callPackage ./pkgs/nosv/default.nix { };
    openmp = callPackage ./pkgs/llvm-ompss2/openmp.nix { monorepoSrc = final.clangOmpss2Unwrapped.src; version = final.clangOmpss2Unwrapped.version; };
    openmpv = final.openmp.override { enableNosv = true; enableOvni = true; };
    osumb = callPackage ./pkgs/osu/default.nix { };
    ovni = callPackage ./pkgs/ovni/default.nix { };
    ovniGit = final.ovni.override { useGit = true; };
    paraverKernel = callPackage ./pkgs/paraver/kernel.nix { };
    prometheus-slurm-exporter = prev.callPackage ./pkgs/slurm-exporter/default.nix { };
    #pscom = callPackage ./pkgs/parastation/pscom.nix { }; # Unmaintaned
    #psmpi = callPackage ./pkgs/parastation/psmpi.nix { }; # Unmaintaned
    slurm = import ./pkgs/slurm/default.nix { slurm = prev.slurm; };
    sonar = callPackage ./pkgs/sonar/default.nix { };
    stdenvClangOmpss2 = final.stdenv.override { cc = final.clangOmpss2; allowedRequisites = null; };
    stdenvClangOmpss2Nanos6 = final.stdenv.override { cc = final.clangOmpss2Nanos6; allowedRequisites = null; };
    stdenvClangOmpss2Nodes = final.stdenv.override { cc = final.clangOmpss2Nodes; allowedRequisites = null; };
    stdenvClangOmpss2NodesOmpv = final.stdenv.override { cc = final.clangOmpss2NodesOmpv; allowedRequisites = null; };
    tagaspi = callPackage ./pkgs/tagaspi/default.nix { };
    tampi = callPackage ./pkgs/tampi/default.nix { };
    upc-qaire-exporter = prev.callPackage ./pkgs/upc-qaire-exporter/default.nix { };
    wxparaver = callPackage ./pkgs/paraver/default.nix { };
  };

  tests = rec {
    hwloc = callPackage ./test/bugs/hwloc.nix { };
    #sigsegv = callPackage ./test/reproducers/sigsegv.nix { };
    hello-c = callPackage ./test/compilers/hello-c.nix { };
    hello-cpp = callPackage ./test/compilers/hello-cpp.nix { };
    lto = callPackage ./test/compilers/lto.nix { };
    asan = callPackage ./test/compilers/asan.nix { };
    intel2023-icx-c   = hello-c.override   { stdenv = final.intelPackages_2023.stdenv; };
    intel2023-icc-c   = hello-c.override   { stdenv = final.intelPackages_2023.stdenv-icc; };
    intel2023-icx-cpp = hello-cpp.override { stdenv = final.intelPackages_2023.stdenv; };
    intel2023-icc-cpp = hello-cpp.override { stdenv = final.intelPackages_2023.stdenv-icc; };
    intel2023-ifort   = callPackage ./test/compilers/hello-f.nix {
      stdenv = final.intelPackages_2023.stdenv-ifort;
    };
    clangOmpss2-lto   = lto.override       { stdenv = final.stdenvClangOmpss2Nanos6; };
    clangOmpss2-asan  = asan.override      { stdenv = final.stdenvClangOmpss2Nanos6; };
    clangOmpss2-task  = callPackage ./test/compilers/ompss2.nix {
      stdenv = final.stdenvClangOmpss2Nanos6;
    };
    clangNodes-task = callPackage ./test/compilers/ompss2.nix {
      stdenv = final.stdenvClangOmpss2Nodes;
    };
    clangNosvOpenmp-task = callPackage ./test/compilers/clang-openmp.nix {
      stdenv = final.stdenvClangOmpss2Nodes;
    };
    clangNosvOmpv-nosv = callPackage ./test/compilers/clang-openmp-nosv.nix {
      stdenv = final.stdenvClangOmpss2NodesOmpv;
    };
    clangNosvOmpv-ld = callPackage ./test/compilers/clang-openmp-ld.nix {
      stdenv = final.stdenvClangOmpss2NodesOmpv;
    };
  };

  # For now, only build toplevel packages in CI/Hydra
  pkgsTopLevel = filterAttrs (_: isDerivation) bscPkgs;

  # Native build in that platform doesn't imply cross build works
  canCrossCompile = platform: default: pkg:
    (isDerivation pkg) &&
    # If meta.cross is undefined, use default
    (pkg.meta.cross or default) &&
    (meta.availableOn final.pkgsCross.${platform}.stdenv.hostPlatform pkg);

  # For now only RISC-V
  crossSet = genAttrs [ "riscv64" ] (platform:
    filterAttrs (_: canCrossCompile platform true)
      final.pkgsCross.${platform}.bsc.pkgsTopLevel);

  buildList = name: paths:
    final.runCommandLocal name { } ''
      printf '%s\n' ${toString paths} | tee $out
    '';

  buildList' = name: paths:
    final.runCommandLocal name { } ''
      deps="${toString paths}"
      cat $deps
      printf '%s\n' $deps >$out
    '';

  pkgsList = buildList "ci-pkgs" (builtins.attrValues pkgsTopLevel);
  testsList = buildList "ci-tests" (collect isDerivation tests);
  allList = buildList' "ci-all" [ pkgsList testsList ];
  # For now only RISC-V
  crossList = buildList "ci-cross"
    (filter
      (canCrossCompile "riscv64" false) # opt-in (pkgs with: meta.cross = true)
        (builtins.attrValues crossSet.riscv64));

in bscPkgs // {

  lib = prev.lib // {
    maintainers = prev.lib.maintainers // {
      bsc = import ./pkgs/maintainers.nix;
    };
  };

  # Prevent accidental usage of bsc-ci attribute
  bsc-ci = throw "the bsc-ci attribute is deprecated, use bsc.ci";

  # Internal for our CI tests
  bsc = {
    # CI targets for nix build
    ci = { pkgs = pkgsList; tests = testsList; all = allList; cross = crossList; };

    # Direct access to package sets
    tests = tests;
    pkgs = bscPkgs;
    pkgsTopLevel = pkgsTopLevel;
    cross = crossSet;

    # Hydra uses attribute sets of pkgs
    hydraJobs = { tests = tests; pkgs = pkgsTopLevel; cross = crossSet; };
  };
}
