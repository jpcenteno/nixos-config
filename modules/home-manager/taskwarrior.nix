{ ... }:
{
  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-16";
    config = {
      # Set INBOX as the default project to capture new tasks.
      default.project = "INBOX";

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

  programs.bash.shellAliases.t = "task";
}
