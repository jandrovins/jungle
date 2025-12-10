{ stdenv
, lib
, amd-uprof
, kernel
, runCommandLocal
}:

let
  version = amd-uprof.version;
  tarball = amd-uprof.src;
in stdenv.mkDerivation {
  pname = "AMDPowerProfilerDriver";
  inherit version;
  src = runCommandLocal "AMDPowerProfilerDriverSource.tar.gz" { } ''
    set -x
    tar -x -f ${tarball} AMDuProf_Linux_x64_${version}/bin/AMDPowerProfilerDriverSource.tar.gz
    mv AMDuProf_Linux_x64_${version}/bin/AMDPowerProfilerDriverSource.tar.gz $out
    set +x
  '';
  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;
  patches = [ ./makefile.patch ./hrtimer.patch ./remove-wr-rdmsrq.patch ];
  makeFlags = [
    "KERNEL_VERSION=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  meta = {
    description = "AMD Power Profiler Driver";
    homepage = "https://www.amd.com/es/developer/uprof.html";
    platforms = lib.platforms.linux;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers.bsc; [ rarias varcila ];
  };
}
