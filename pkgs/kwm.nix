{ stdenv, lib, zig, pkg-config, wayland-protocols, wayland-scanner, wayland, libxkbcommon, pixman, fcft, src }:

let
  zigDeps = zig.fetchDeps {
    pname = "kwm";
    version = "unstable";
    inherit src;
    fetchAll = true;
    hash = "sha256-Lz/Wcy40rxN81n/mBj4YJVbyGOolHzSFZMs93T1h0oQ=";
  };
in
stdenv.mkDerivation {
  pname = "kwm";
  version = "unstable";
  inherit src;

  nativeBuildInputs = [
    zig.hook
    pkg-config
    wayland-protocols
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
    pixman
    fcft
  ];

  preBuild = ''
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"
    mkdir -p "$ZIG_GLOBAL_CACHE_DIR/p"
    cp -r ${zigDeps}/* "$ZIG_GLOBAL_CACHE_DIR/p/"
    chmod -R +w "$ZIG_GLOBAL_CACHE_DIR"
  '';

  zigBuildFlags = [
    "-Doptimize=ReleaseSafe"
  ];

  meta = with lib; {
    description = "A DWM-like dynamic tiling window manager for River";
    homepage = "https://github.com/kewuaa/kwm";
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "kwm";
  };
}
