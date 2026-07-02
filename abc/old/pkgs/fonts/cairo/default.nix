{
  lib,
  stdenv,
  unzip,
  ...
}: let
  pname = "cairo";
  version = "2023-02-11";
in
  stdenv.mkDerivation {
    name = "${pname}-${version}";
    src = ./Cairo-v2023-02-11.zip;
    buildInputs = [unzip];
    installPhase = ''
      install -m444 -Dt $out/share/fonts/truetype *.ttf
    '';
    meta = with lib; {
      description = "Cairo Font";
      longDescription = "Cairo is a contemporary multilingual typeface family.";
      homepage = "https://fonts.google.com/specimen/Cairo/about";
      license = licenses.ofl;
      platforms = platforms.all;
    };
  }
