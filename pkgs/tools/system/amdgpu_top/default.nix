{ lib
, rustPlatform
, fetchFromGitHub
, libdrm
, libX11
, libGL
, wayland
, wayland-protocols
, libxkbcommon
, libXrandr
, libXi
, libXcursor
}:

rustPlatform.buildRustPackage rec {
  pname = "amdgpu_top";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "Umio-Yasuno";
    repo = pname;
    rev = "v${version}-stable";
    hash = "sha256-cdKUj0pUlXxMNx0jypuov4hX3CISTDaSQh+KFB5R8ys=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  buildInputs = [
    libdrm
    libX11
    libGL
    wayland
    wayland-protocols
    libxkbcommon
    libXrandr
    libXi
    libXcursor
  ];

  postInstall = ''
    install -D ./assets/${pname}.desktop -t $out/share/applications/
  '';

  postFixup = ''
    patchelf --set-rpath "${lib.makeLibraryPath buildInputs}" $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Tool to display AMDGPU usage";
    homepage = "https://github.com/Umio-Yasuno/amdgpu_top";
    changelog = "https://github.com/Umio-Yasuno/amdgpu_top/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ geri1701 ];
  };
}
