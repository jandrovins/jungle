{ python3Packages, lib }:

python3Packages.buildPythonApplication {
  pname = "upc-qaire-exporter";
  version = "1.0";

  pyproject = true;

  src = ./.;

  doCheck = false;

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    prometheus-client
    requests
  ];

  meta = with lib; {
    description = "UPC Qaire Prometheus Exporter";
    platforms = platforms.linux;
  };
}
