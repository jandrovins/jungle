{ stdenv
, lib
, curl
, cacert
, runCommandLocal
, autoPatchelfHook
, elfutils
, glib
, libGL
, ncurses5
, xorg
, zlib
, libxkbcommon
, freetype
, fontconfig
, libGLU
, dbus
, rocmPackages
, libxcrypt-legacy
, numactl
, radare2
}:

let
  version = "5.1.701";
  tarball = "AMDuProf_Linux_x64_${version}.tar.bz2";

  # NOTE: Remember to update the radare2 patch below if AMDuProfPcm changes.
  uprofSrc = runCommandLocal tarball {
    nativeBuildInputs = [ curl ];
    outputHash = "sha256-j9gxcBcIg6Zhc5FglUXf/VV9bKSo+PAKeootbN7ggYk=";
    SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt";
  } ''
    curl \
    -o $out \
    'https://download.amd.com/developer/eula/uprof/uprof-5-1/${tarball}' \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:139.0) Gecko/20100101 Firefox/139.0' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Accept-Encoding: gzip, deflate, br, zstd' \
    -H 'Referer: https://www.amd.com/' 2>&1 | tr '\r' '\n'
  '';

in
  stdenv.mkDerivation {
    pname = "AMD-uProf";
    inherit version;
    src = uprofSrc;
    dontStrip = true;
    phases = [ "installPhase" "fixupPhase" ];
    nativeBuildInputs = [ autoPatchelfHook radare2 ];
    buildInputs = [
      stdenv.cc.cc.lib
      ncurses5
      elfutils
      glib
      libGL
      libGLU
      libxcrypt-legacy
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXmu
      xorg.libxcb
      xorg.xcbutilwm
      xorg.xcbutilrenderutil
      xorg.xcbutilkeysyms
      xorg.xcbutilimage
      fontconfig.lib
      libxkbcommon
      zlib
      freetype
      dbus
      rocmPackages.rocprofiler
      numactl
    ];
    installPhase = ''
      set -x
      mkdir -p $out
      tar -x -v -C $out --strip-components=1 -f $src
      rm $out/bin/AMDPowerProfilerDriverSource.tar.gz
      patchelf --replace-needed libroctracer64.so.1 libroctracer64.so $out/bin/ProfileAgents/x64/libAMDGpuAgent.so
      patchelf --add-needed libcrypt.so.1 --add-needed libstdc++.so.6 $out/bin/AMDuProfSys
      echo "16334a51fcc48668307ad94e20482ca4  $out/bin/AMDuProfPcm" | md5sum -c -
      radare2 -w -q -i ${./libnuma.r2} $out/bin/AMDuProfPcm
      patchelf --add-needed libnuma.so $out/bin/AMDuProfPcm
      set +x
    '';

    meta = {
      description = "Performance analysis tool-suite for x86 based applications";
      homepage = "https://www.amd.com/es/developer/uprof.html";
      platforms = [ "x86_64-linux" ];
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers.bsc; [ rarias varcila ];
    };

  }
