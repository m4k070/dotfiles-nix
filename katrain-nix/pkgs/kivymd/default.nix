{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, kivy
, pillow
, requests
}:

buildPythonPackage rec {
  pname = "kivymd";
  version = "0.104.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ncvCy4r/3pyCVyGY/dsyyBTN1XJUoOSwDFOILbLI1qY=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    kivy
    pillow
    requests
  ];

  # テストはGUI環境が必要
  doCheck = false;

  meta = {
    description = "Material Design component library for Kivy";
    homepage = "https://github.com/kivymd/KivyMD";
    license = lib.licenses.mit;
  };
}
