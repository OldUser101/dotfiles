let
  olduser101 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICeXZ8vRxqvcxCaOehuxN50MoTp5b7UNRIsn9FvW327x";
in
{
  "email-password.age" = {
    publicKeys = [ olduser101 ];
    armor = true;
  };
}
