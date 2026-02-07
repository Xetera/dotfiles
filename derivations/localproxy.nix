{ pkgs, lib }:

let
  envoy = import ./envoy.nix { inherit pkgs lib; stdenv = pkgs.stdenv; };
in
pkgs.buildGoModule {
  pname = "localproxy";
  version = "0.0.1";

  src = fetchGit {
    url = "https://github.com/xetera/localproxy";
    ref = "main";
    rev = "2c3b40422942d51673cc87ea5d549c33c8937989";
  };

  vendorHash = "sha256-QOsy6PlqLmO6YU0ybgyfIYDkPKc1hTC4UJukYJqZ6/0=";

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
