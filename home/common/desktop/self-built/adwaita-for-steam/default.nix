{
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  ...
}:
stdenvNoCC.mkDerivation rec {
  name = "adwaita-for-steam";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "tkashkin";
    repo = "Adwaita-for-Steam";
    rev = "v${version}";
    sha256 = "pFJnioylRhnC3lGGkBLMXvakzt/XvoCXPDqepXskPfI=";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [python3];

  patches = [./install.patch];

  installPhase = ''
    mkdir -p $out/build
    NIX_OUT="$out" python install.py -c Catppuccin-Mocha -we library/hide_whats_new -we library/sidebar_hover -we login/hover_qr -we windowcontrols/hide-close
  '';
}
