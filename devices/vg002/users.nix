{
  username,
  userHashedPassword,
  rootHashedPassword,
  sshKey,
}: {...}: {
  users.users.${username} = {
    description = "Main User";
    isNormalUser = true;
    extraGroups = ["wheel"];
    hashedPassword = userHashedPassword;
    openssh.authorizedKeys.keys = [sshKey];
  };

  users.users.root = {
    hashedPassword = rootHashedPassword;
    openssh.authorizedKeys.keys = [sshKey];
  };
}
