{ stdenv, fetchurl, appimageTools }:

stdenv.mkDerivation rec {
  pname = "AmneziaVPN";
  version = "4.8.4.4";

  src = fetchurl {
    url = "https://github.com/amnezia-vpn/amnezia-client/releases/download/${version}/AmneziaVPN_${version}_macos.dmg";
    sha256 = "sha256-hash";
  };

  nativeBuildInputs = [ appimageTools ];

  installPhase = ''
    mkdir -p $out/Applications
    hdiutil attach $src -mountpoint /Volumes/ExampleApp
    cp -R /Volumes/ExampleApp/Example.app $out/Applications/
    hdiutil detach /Volumes/ExampleApp
  '';
}
