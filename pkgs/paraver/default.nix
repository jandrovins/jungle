{
  stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, boost
, libxml2
, xml2
, wxGTK32
, autoconf
, automake
, paraverKernel
, openssl
, glibcLocales
, wrapGAppsHook3
}:

let
  wx = wxGTK32;
in
stdenv.mkDerivation rec {
  pname = "wxparaver";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "bsc-performance-tools";
    repo = "wxparaver";
    rev = "v${version}";
    sha256 = "sha256-YsO5gsuEFQdki3lQudEqgo5WXOt/fPdvNw5OxZQ86Zo=";
  };

  patches = [
    ./do-not-steal-focus-on-redraw.patch

    # Fix for boost >=1.87 (thanks to gamezelda)
    # https://aur.archlinux.org/cgit/aur.git/commit/?h=wxparaver&id=b0dcd08c472536e0a1a3cc1dfbc4c77d9f5e0d47
    ./fix-boost-87.patch
  ];

  hardeningDisable = [ "all" ];

  # Fix the PARAVER_HOME variable
  postPatch = ''
    sed -i 's@^PARAVER_HOME=.*$@PARAVER_HOME='$out'@g' docs/wxparaver
    sed -i '1aexport LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"' docs/wxparaver
  '';

  dontStrip = true;
  enableParallelBuilding = true;

  preConfigure = ''
    export CFLAGS="-O3"
    export CXXFLAGS="-O3"
  '';

  configureFlags = [
    "--with-boost=${boost}"
    "--with-wx-config=${wx}/bin/wx-config"
    "--with-paraver=${paraverKernel}"
    "--with-openssl=${openssl.dev}"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    autoreconfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    boost
    libxml2.dev
    xml2
    wx
    paraverKernel
    openssl.dev
  ];

  postInstall = ''
    mkdir -p $out/include
    mkdir -p $out/lib/paraver-kernel
    mkdir -p $out/share/filters-config
    cp -p ${paraverKernel}/bin/* $out/bin
    # cp -p ${paraverKernel}/include/* $out/include
    cp -a ${paraverKernel}/lib/paraver-kernel $out/lib/paraver-kernel
    cp -p ${paraverKernel}/share/filters-config/* $out/share/filters-config

    # Move man files to proper location
    mkdir -p $out/share/man
    mv $out/share/doc/wxparaver_help_contents/man $out/share/man/man1
  '';

  meta = {
    homepage = "https://tools.bsc.es/paraver";
    downloadPage = "https://github.com/bsc-performance-tools/wxparaver";
    description = "Performance analyzer based on event traces";
    longDescription = ''
      Trace-based visualization and analysis tool designed to study quantitative
      detailed metrics and obtain qualitative knowledge of the performance of
      applications, libraries, processors and whole architectures
    '';
    maintainers = with lib.maintainers.bsc; [ rarias ];
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21Plus;
  };
}
