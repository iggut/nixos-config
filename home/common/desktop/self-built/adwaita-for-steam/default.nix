{
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  ...
}:
stdenvNoCC.mkDerivation rec {
  name = "adwaita-for-steam";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "tkashkin";
    repo = "Adwaita-for-Steam";
    rev = "v${version}";
    sha256 = "TAQ27Ka2pIZwlltF1Z4rwK0bb+jtlsDs8RZwiE31c88=";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [python3];

  patches = [./install.patch];

  installPhase = ''
    mkdir -p $out/build
    NIX_OUT="$out" python install.py -c catppuccin-mocha -e library/hide_whats_new -e library/sidebar_hover -e login/hover_qr -e windowcontrols/hide-close
  '';
}
