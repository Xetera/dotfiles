{ pkgs, lib, stdenv }:

let
  version = "1.36.4";

  sources = {
    aarch64-darwin = {
      url = "https://ghcr.io/v2/homebrew/core/envoy/blobs/sha256:18a40e57196c60d1596993c55845010caf88ddb83d3b2642e57132ee639c3009";
      sha256 = "18a40e57196c60d1596993c55845010caf88ddb83d3b2642e57132ee639c3009";
    };
    x86_64-darwin = {
      url = "https://ghcr.io/v2/homebrew/core/envoy/blobs/sha256:3032bf14063310000b74c9a579e44579910cfc48d15913777618eb96c9cf2ee6";
      sha256 = "3032bf14063310000b74c9a579e44579910cfc48d15913777618eb96c9cf2ee6";
    };
  };

  src = sources.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "envoy";
  inherit version;

  src = pkgs.fetchurl {
    url = src.url;
    sha256 = src.sha256;
  };

  nativeBuildInputs = [ pkgs.gnutar ];

  unpackPhase = ''
    tar -xzf $src
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/envoy
    cp envoy/${version}/bin/envoy $out/bin/envoy
    cp -r envoy/${version}/share/envoy/configs $out/share/envoy/
  '';

  meta = with lib; {
    description = "Cloud-native high-performance edge/middle/service proxy";
    homepage = "https://www.envoyproxy.io/";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
}
