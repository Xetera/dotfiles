{ pkgs, lib }:

pkgs.buildGoModule rec {
  pname = "spoofdpi";
  version = "1.0.2";

  src = pkgs.fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = "v${version}";
    sha256 = "sha256-VRgrw9E20HaUduW23ADTwPPM87bDbPdcv4Pxm5QGm5k=";
  };

  vendorHash = "sha256-EkuzmGv+5pXr8r301BXu+e5Cb+D1HT+OsIk/ckLBfdw=";

  buildInputs = [ pkgs.libpcap ];

  # Build flags as specified in the project
  ldflags = [ "-w" "-s" ];

  # Enable CGO for libpcap bindings
  env = {
    CGO_ENABLED = "1";
  };

  # Build the main binary from cmd/spoofdpi directory
  subPackages = [ "cmd/spoofdpi" ];

  meta = with lib; {
    description = "A simple proxy tool to bypass Deep Packet Inspection (DPI) censorship";
    homepage = "https://github.com/xvzc/SpoofDPI";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
