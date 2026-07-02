# NOTE: Download at https://dubaifont.com/download
{
  lib,
  stdenv,
  unzip,
  ...
}: let
  pname = "dubai";
  version = "2023-02-11";
in
  stdenv.mkDerivation {
    name = "${pname}-${version}";
    src = ./Dubai-v2023-02-11.zip;
    sourceRoot = "ot_ttf";
    buildInputs = [unzip];
    installPhase = ''
      install -m444 -Dt $out/share/fonts/truetype *.ttf
    '';
    meta = with lib; {
      description = "Dubai Font";
      longDescription = "A font inspired by the city of Dubai, that was made to create harmony between Latin and Arabic.";
      homepage = "https://dubaifont.com";
      license = licenses.unfree;
      platforms = platforms.all;
    };
  }
