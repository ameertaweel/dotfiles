{
  username,
  hashedPassword,
  sshKey,
}: {...}: {
  users.groups.${username} = {};
  users.users.${username} = {
    description = "Main User";
    isNormalUser = true;
    group = username;
    extraGroups = ["wheel"];
    hashedPassword = hashedPassword;
    openssh.authorizedKeys.keys = [sshKey];
  };

  users.users.root.openssh.authorizedKeys.keys = [sshKey];
}
