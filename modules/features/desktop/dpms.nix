{
  flake.modules.homeManager.dpms = { lib, ... }: let
    mkShellArgsOption = attrs: lib.mkOption ({
      type = lib.types.listOf lib.types.str;
      defaultText = "[ \"<program>\" \"<arg1>\" \"<arg2>\" ]";
    } // attrs);
  in {
    options.dpms.powerOffAllMonitorsShellArgs = mkShellArgsOption {
      description = "Command and arguments used to power off all monitors";
    };

    options.dpms.powerOnAllMonitorsShellArgs = mkShellArgsOption {
      description = "Command and arguments used to power on all monitors";
    };
  };
}
