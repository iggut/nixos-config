{
  config,
  pkgs,
  cosmic-applets,
  cosmic-applibrary,
  cosmic-comp,
  cosmic-launcher,
  cosmic-notifications,
  cosmic-osd,
  cosmic-panel,
  cosmic-settings,
  cosmic-settings-daemon,
  cosmic-session,
  xdg-desktop-portal-cosmic,
  ...
}: {
  environment.systemPackages = with pkgs; [
    cosmic-applets.packages."${pkgs.system}".default
    cosmic-applibrary.packages."${pkgs.system}".default
    cosmic-comp.packages."${pkgs.system}".default
    cosmic-launcher.packages."${pkgs.system}".default
    cosmic-notifications.packages."${pkgs.system}".default
    # cosmic-osd.packages."${pkgs.system}".default
    cosmic-panel.packages."${pkgs.system}".default
    cosmic-settings.packages."${pkgs.system}".default
    cosmic-settings-daemon.packages."${pkgs.system}".default
    cosmic-session.packages."${pkgs.system}".default
    # xdg-desktop-portal-cosmic.packages."${pkgs.system}".default
  ];
}
