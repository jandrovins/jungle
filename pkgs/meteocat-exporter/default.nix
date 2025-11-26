{ python3Packages, lib }:

python3Packages.buildPythonApplication {
  pname = "meteocat-exporter";
  version = "1.0";

  pyproject = true;

  src = ./.;

  doCheck = false;

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    lxml
    prometheus-client
  ];

  meta = with lib; {
    description = "MeteoCat Prometheus Exporter";
    platforms = platforms.linux;
  };
}
