{ lib
, buildPythonApplication
, fetchPypi
, kivy
, kivymd
, chardet
, docutils
, ffpyplayer
, screeninfo
, urllib3
, pillow
, katago
, makeWrapper
, hatchling
}:

buildPythonApplication rec {
  pname = "katrain";
  version = "1.17.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TiND+RzJgI3GhPGRNRHNE3V29NgFHGx1VUX2jXTA1J8=";
  };

  nativeBuildInputs = [ makeWrapper hatchling ];

  propagatedBuildInputs = [
    kivy
    kivymd
    chardet
    docutils
    ffpyplayer
    screeninfo
    urllib3
    pillow
  ];

  # KataGoのパスをwrapする
  postInstall = ''
    wrapProgram $out/bin/katrain \
      --prefix PATH : ${lib.makeBinPath [ katago ]}
  '';

  # GUIアプリのためテストをスキップ
  doCheck = false;

  meta = {
    description = "KaTrain: AI-assisted Go training with KataGo";
    homepage = "https://github.com/sanderland/katrain";
    license = lib.licenses.mit;
    mainProgram = "katrain";
  };
}
