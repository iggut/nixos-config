_: {
  windowrulev2 = [
    # only allow shadows for floating windows
    "noshadow, floating:0"

    # idle inhibit while watching videos
    "idleinhibit focus, class:^(mpv|.+exe)$"
    "idleinhibit fullscreen, class:.*"

    # make Firefox PiP window floating and sticky
    "float, title:^(Picture-in-Picture)$"
    "pin, title:^(Picture-in-Picture)$"

    "float, class:^(1Password)$"
    "stayfocused,title:^(Quick Access — 1Password)$"
    "dimaround,title:^(Quick Access — 1Password)$"
    "noanim,title:^(Quick Access — 1Password)$"

    "float, class:^(org.gnome.*)$"
    "float, class:^(pavucontrol)$"
    "float, class:(blueberry\.py)"

    # make pop-up file dialogs floating, centred, and pinned
    "float, title:(Open|Progress|Save File)"
    "center, title:(Open|Progress|Save File)"
    "pin, title:(Open|Progress|Save File)"
    "float, class:^(code)$"
    "center, class:^(code)$"
    "pin, class:^(code)$"

    # assign windows to workspaces
    "workspace 1 silent, class:startup-alacritty"
    "workspace 2 silent, class:[Ff]irefox"
    "workspace 2 silent, class:[Oo]bsidian"
    "workspace 3 silent, class:WebCord"
    "workspace 4 silent, class:steam"
    "workspace 5 silent, class:codium-url-handler"
    "workspace 9 silent, class:looking-glass-client"

    "workspace 7 silent, class:task-managers"

    # Remove transparancy from video
    "opaque, title:^(Netflix)(.*)$"
    "opaque, title:^(.*YouTube.*)$"
    "opaque, title:^(Picture-in-Picture)$"
    "opaque, class:^(looking-glass-client)$"

    # steam center and fload + friends list size
    "size 350 950,class:^(steam)$ title:^(Friends)(.*)$"
    "float,class:^(steam)$ title:^(Friends)(.*)$"
    "center,class:^(steam)$ title:^(Friends)(.*)$"
  ];
}
