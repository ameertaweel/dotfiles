# View configuration diff between last and current system builds
{
  coreutils-full,
  nvd,
  writeShellScriptBin,
  ...
}:
writeShellScriptBin "nixos-rebuild-summary" ''
  BUILDS=$(${coreutils-full}/bin/ls -d1v /nix/var/nix/profiles/system-*-link | tail -n 2)
  ${nvd}/bin/nvd diff ''${BUILDS}
''
