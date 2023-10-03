{ pkgs, secrets, ... }:

with pkgs;

let vbiosPatcher =
  stdenv.mkDerivation {
    name = "vbios-patcher";

    src = pkgs.fetchgit {
      url = "https://github.com/Marvo2011/NVIDIA-vBIOS-VFIO-Patcher.git";
      rev = "f10bbb95f797873c769c49f0cff06cf471d01c5a";
      sha256 = "0s7n3bg32yvig63b8fkk780janc4b1jxwhhl0j08is3h363xclrg";
    };

    installPhase = ''
      mkdir -p $out
      cp nvidia_vbios_vfio_patcher.py $out/nvidia_vbios_vfio_patcher.py
    '';
  };
in
stdenv.mkDerivation {
  name = "patched-vbios";

  buildInputs = [ pkgs.python3 ];

  src = secrets.rtxRom;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    python ${vbiosPatcher}/nvidia_vbios_vfio_patcher.py -i $src -o $out/patched.rom --skip-the-very-important-warning
  '';
}
