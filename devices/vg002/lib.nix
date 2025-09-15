rec {
  splitString = sep: s:
    builtins.filter builtins.isString (builtins.split sep s);

  readShellScript = path: let
    fileContent = builtins.readFile path;
    lines = splitString "\n" fileContent;
    excludeShebang = builtins.tail lines;
  in
    builtins.concatStringsSep "\n" excludeShebang;
}
