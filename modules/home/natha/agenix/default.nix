{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.agenix;
  secrets = ../../../../secrets;
in
{
  options.olduser101.agenix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable agenix (secrets) configuration";
    };

    identityPaths = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "SSH identity paths";
    };
  };

  config = mkIf cfg.enable {
    age = {
      identityPaths = cfg.identityPaths;
      secrets = {
        email-password.file = "${secrets}/email-password.age";
      };
    };
  };
}
