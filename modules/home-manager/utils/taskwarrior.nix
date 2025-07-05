{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.utils.taskwarrior;
in
{
  options.jpcenteno-home.utils.taskwarrior = {
    enable = lib.mkEnableOption "taskwarrior";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.taskwarrior-tui ];

    programs = {
      taskwarrior = {
        enable = true;
        colorTheme = "dark-16";
        config = {
          # Set INBOX as the default project to capture new tasks.
          default.project = "INBOX";

          urgency = {
            # Not  actually  a  coefficient. When enabled, blocking tasks inherit the
            # highest urgency value found in the tasks they block. This is done
            # recursively.  It is recommended to set urgency.blocking.coefficient and
            # urgency.blocked.coefficient to 0.0 in order for this setting to be the
            # most useful
            "inherit" = 1;
            # Urgency coefficient for blocking tasks:
            blocking.coefficient = 0.0;
            # Urgency coefficient for blocked tasks:
            blocked.coefficient = 0.0;
          };

          report = {
            # Exclude tasks in the inbox (project:INBOX) from the `next` report.
            next.filter = "status:pending -WAITING limit:page project.not:INBOX";

            # List every task in the inbox.
            inbox = {
              description = "Show inbox";
              columns = "id,description.count,tags,entry.age";
              labels = "ID,Description,Tags,Age";
              filter = "status:pending project:INBOX";
            };

            someday = {
              description = "Tasks saved for some day in the future";
              columns = "id,entry.age,depends,project,tags,description";
              labels = "ID,Age,Deps,Project,Tag,Description";
              filter = "+WAITING wait.after:7000years";
            };

            waiting.filter = "+WAITING wait.before:7000years";
          };
        };
      };

      bash.shellAliases = {
        t = "task";
        ttui = "taskwarrior-tui";
      };
    };
  };
}
