{ stdenv, lib, zig, pkg-config, wayland-protocols, wayland-scanner, wayland, libxkbcommon, pixman, fcft, src }:

let
  zigCache = stdenv.mkDerivation {
    pname = "kwm-cache";
    version = "unstable";
    inherit src;
    nativeBuildInputs = [
      zig
      pkg-config
      wayland-protocols
      wayland-scanner
      wayland
      libxkbcommon
      pixman
      fcft
    ];
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-kumYOQcmEu1zzEBK+F9hQVYTmw0hVmJE2XLkdLtuxNM=";

    buildPhase = ''
      export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"
      if [ -f config.def.zon ] && [ ! -f config.zon ]; then
        cp config.def.zon config.zon
      fi
      zig build -Doptimize=ReleaseSafe

      mkdir -p "$out"
      if [ -d "$ZIG_GLOBAL_CACHE_DIR/p" ]; then
        cp -r "$ZIG_GLOBAL_CACHE_DIR/p" "$out/p"
      fi
    '';

    installPhase = "true";
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

  postPatch = ''
    if [ -f config.def.zon ] && [ ! -f config.zon ]; then
      cp config.def.zon config.zon
    fi
  '';

  preBuild = ''
    export ZIG_GLOBAL_CACHE_DIR="$NIX_BUILD_TOP/zig-cache"
    mkdir -p "$ZIG_GLOBAL_CACHE_DIR/p"
    if [ -d "${zigCache}/p" ]; then
      cp -r ${zigCache}/p/* "$ZIG_GLOBAL_CACHE_DIR/p/"
    fi
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
