{ stdenv, fetchurl, pkgs, cpio, xar, ... }:

stdenv.mkDerivation rec {
  pname = "AmneziaVPN";
  version = "4.8.4.4";

  src = fetchurl {
    url = "https://github.com/amnezia-vpn/amnezia-client/releases/download/${version}/AmneziaVPN_${version}_macos.dmg";
    sha256 = "sha256-QKDbYRs1USoB2oBZWp3XuMKK82o/WlokjKRJ/zH3Y9k=";
  };

  sourceRoot = ".";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/Applications
    /usr/bin/hdiutil attach $src -mountpoint /Volumes/AmneziaVPN
    cp -R /Volumes/AmneziaVPN/AmneziaVPN.app "$out/Applications/"
    ls -la $out/Applications/AmneziaVPN.app
    /usr/bin/hdiutil detach /Volumes/AmneziaVPN
    ls -la $out
  '';

  meta = {
    description = "Amnezia VPN Client";
    homepage = "https://github.com/AmneziaVPN/amnezia-client";
    license = pkgs.lib.licenses.gpl3;
  };
}
