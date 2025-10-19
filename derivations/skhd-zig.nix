{ pkgs }:

let
  versionNum = "0.0.15";
in
pkgs.stdenv.mkDerivation {
  pname = "skhd-zig";
  version = versionNum;

  src = pkgs.fetchurl {
    url = "https://github.com/jackielii/skhd.zig/releases/download/v${versionNum}/skhd-arm64-macos.tar.gz";
    sha256 = "3bd1a35a257248db2f2fe37ed22e4c1affd2236156ef06c2dbe630e16c588b47";
  };

  unpackPhase = ":";
  installPhase = ''
    mkdir -p $out/bin
    tar -xzf $src -C $out/bin --transform='s|skhd-arm64-macos|skhd|'
  '';
}
