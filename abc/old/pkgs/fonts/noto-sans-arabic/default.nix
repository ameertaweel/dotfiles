# NOTE: GitHub repo at https://github.com/notofonts/arabic
{
  lib,
  stdenv,
  unzip,
  ...
}: let
  pname = "noto-sans-arabic";
  version = "2.010";
in
  stdenv.mkDerivation {
    name = "${pname}-${version}";
    src = ./NotoSansArabic-v2.010.zip;
    buildInputs = [unzip];
    installPhase = ''
      install -m444 -Dt $out/share/fonts/opentype full/otf/*.otf
    '';
    meta = with lib; {
      description = "Noto Sans Arabic Font";
      longDescription = "Noto Sans Arabic is an unmodulated (“sans serif”) design for texts in the Middle Eastern Arabic script.";
      homepage = "https://github.com/notofonts/arabic";
      license = licenses.ofl;
      platforms = platforms.all;
    };
  }
