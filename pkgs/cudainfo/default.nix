{
  stdenv
, lib
, cudatoolkit
, cudaPackages
, autoAddDriverRunpath
, strace
}:

stdenv.mkDerivation (finalAttrs: {
  name = "cudainfo";
  src = ./.;
  buildInputs = [
    cudatoolkit # Required for nvcc
    (lib.getOutput "static" cudaPackages.cuda_cudart) # Required for -lcudart_static
    autoAddDriverRunpath
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp -a cudainfo $out/bin
  '';
  passthru.gpuCheck = stdenv.mkDerivation {
    name = "cudainfo-test";
    requiredSystemFeatures = [ "cuda" ];
    dontBuild = true;
    nativeCheckInputs = [
      finalAttrs.finalPackage # The cudainfo package from above
      strace # When it fails, it will show the trace
    ];
    dontUnpack = true;
    doCheck = true;
    checkPhase = ''
      if ! cudainfo; then
        set -x
        cudainfo=$(command -v cudainfo)
        ldd $cudainfo
        readelf -d $cudainfo
        strace -f $cudainfo
        set +x
      fi
    '';
    installPhase = "touch $out";
  };

  meta = {
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers.bsc; [ rarias ];
  };
})
