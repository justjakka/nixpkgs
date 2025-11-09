{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  cmake,
  pkg-config,
  rustPlatform,
  rustc,
  packaging,
  pillow,
  numpy,
  py3exiv2,
  pytest,
}:

buildPythonPackage rec {
  pname = "pillow-jpegxl";
  version = "1.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Isotr0py";
    repo = "pillow-jpegxl-plugin";
    rev = "v${version}";
    hash = "sha256-hQt273eYPlXNuHWtanRvD2BZ8tTBzu+E06TcQuL7SgA=";
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  build-system = [
    cargo
    cmake
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dontUseCmakeConfigure = true;

  dependencies = [
    packaging
    pillow
  ];

  optional-dependencies = {
    dev = [
      numpy
      py3exiv2
      pytest
    ];
  };

  pythonImportsCheck = [ "pillow_jxl" ];

  meta = {
    description = "Pillow plugin for JPEG-XL, using Rust for bindings";
    homepage = "https://github.com/Isotr0py/pillow-jpegxl-plugin";
    license = lib.licenses.gpl3Only;
    maintainers = with maintainers; [ jakka ];
  };
}
