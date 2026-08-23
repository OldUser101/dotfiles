{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.wl-overlay;
in
{
  options.olduser101.wl-overlay = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable wl-overlay configuration";
    };

    battery = mkOption {
      type = types.bool;
      default = false;
      description = "Enable wl-overlay battery widget";
    };
  };

  config = mkIf cfg.enable {
    programs.wl-overlay = {
      enable = true;
      layers = [
        {
          anchors = [ ];
          name = "centre-panel";
          refresh = 1000;
          hide = true;
          root = {
            type = "panel";
            gap = 10;
            background = "#00000000";
            children = [
              {
                type = "box";
                background = "#1e1e2e";
                border-color = "#cba6f7";
                border-width = 2;
                padding-bottom = 5;
                padding-left = 5;
                padding-right = 5;
                padding-top = 5;
                child = {
                  type = "panel";
                  alignment = "center";
                  background = "#1e1e2e";
                  width = 300;
                  children = [
                    {
                      type = "panel";
                      direction = "right";
                      gap = 10;
                      height = 50;
                      alignment = "center";
                      background = "#1e1e2e";
                      children = [
                        {
                          type = "datetime";
                          format = "%H:%M";
                          child = {
                            type = "text";
                            background = "#1e1e2e";
                            color = "#f9e2af";
                            size = 50.0;
                          };
                        }
                        {
                          type = "box";
                          background = "#1e1e2e";
                          padding-top = 5;
                          child = {
                            type = "panel";
                            height = 45;
                            alignment = "center";
                            background = "#1e1e2e";
                            children = [
                              {
                                type = "datetime";
                                format = "%a %b %d";
                                child = {
                                  type = "text";
                                  background = "#1e1e2e";
                                  color = "#f9e2af";
                                  size = 20.0;
                                };
                              }
                            ];
                          };
                        }
                      ];
                    }
                  ];
                };
              }
            ]
            ++ (optional cfg.battery {
              type = "box";
              background = "#1e1e2e";
              border-color = "#cba6f7";
              border-width = 2;
              padding-bottom = 5;
              padding-left = 5;
              padding-right = 5;
              padding-top = 5;
              child = {
                type = "battery";
                meter = {
                  type = "meter";
                  background = "#1e1e2e";
                  prefix-format = "title";
                  suffix-format = "percentage";
                  bar = {
                    type = "colored-bar";
                    colors = [
                      {
                        min = 50;
                        color = "#a6e3a1";
                      }
                      {
                        min = 20;
                        color = "#f9e2af";
                      }
                      { color = "#f38ba8"; }
                    ];
                    bar = {
                      type = "bar";
                      background = "#1e1e2e";
                      color = "#f38ba8";
                      height = 20;
                      width = 196;
                    };
                  };
                  prefix = {
                    type = "box";
                    background = "#1e1e2e";
                    padding-right = 5;
                    child = {
                      background = "#1e1e2e";
                      color = "#f9e2af";
                      size = 20.0;
                      type = "text";
                    };
                  };
                  suffix = {
                    type = "box";
                    background = "#1e1e2e";
                    padding-left = 5;
                    child = {
                      background = "#1e1e2e";
                      color = "#f9e2af";
                      size = 20.0;
                      type = "text";
                    };
                  };
                };
              };
            });
          };
        }
      ];
    };
  };
}
