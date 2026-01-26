{ pkgs, lib }:

let
  envoy = import ./envoy.nix { inherit pkgs lib; stdenv = pkgs.stdenv; };
in
pkgs.buildGoModule {
  pname = "localproxy";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "xetera";
    repo = "localproxy";
    rev = "main";
    sha256 = "sha256-w5dNM63rAIMQSG+q+a+W+beF7wzVv5jsKvSzes/tVfU=";
  };

  vendorHash = "sha256-RTXxybQ5oykQhBNrhMnW0KP9XXtedk/8OoRMS6jf/gs=";

  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildInputs = with pkgs; [
    mkcert
  ];

  postInstall = ''
    wrapProgram $out/bin/localproxyd \
      --prefix PATH : ${lib.makeBinPath [pkgs.mkcert envoy]}
  '';

  env = {
    CGO_ENABLED = "0";
  };

  subPackages = [ "cmd/localproxyd" ];

  meta = with lib; {
    description = "Turn random port numbers into .localhost domains";
    homepage = "https://github.com/xetera/localproxy";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
