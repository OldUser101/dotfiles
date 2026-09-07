let
  natha-sdafwca = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjFSyyMcgkyUZ/FWGuShnjylvSDvawRLyUqdyz/03EH root@natha-sdafwca";
in
{
  "gh-access-token.age" = {
    publicKeys = [ natha-sdafwca ];
    armor = true;
  };
}
