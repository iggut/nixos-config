_: {
  home.file.".config/git/allowed_signers".text = ''
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMntn36Qko/UqC8tFNaVBgJUtzA/jD4FmJQ0SY5g94KgAAAACXNzaDppZ2d1dA== YK5C
  '';

  programs = {
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };

    git = {
      enable = true;

      userEmail = "igor.gutchin@gmail.com";
      userName = "Igor G";

      aliases = {
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };

      extraConfig = {
        push = {
          default = "matching";
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
        gpg = {
          format = "ssh";
          ssh = {
            defaultKeyCommand = "sh -c 'echo key::$(ssh-add -L | head -n1)'";
            allowedSignersFile = "~/.config/git/allowed_signers";
          };
        };
        commit = {
          gpgSign = true;
        };
        tag = {
          gpgSign = true;
        };
      };

      ignores = [
        "*.fdb_latexmk"
        "*.fls"
        "*.aux"
        "*.glo"
        "*.idx"
        "*.log"
        "*.toc"
        "*.ist"
        "*.acn"
        "*.acr"
        "*.alg"
        "*.bbl"
        "*.blg"
        "*.dvi"
        "*.glg"
        "*.gls"
        "*.ilg"
        "*.ind"
        "*.lof"
        "*.lot"
        "*.maf"
        "*.mtc"
        "*.mtc1"
        "*.out"
        "*.synctex.gz"
        "*.module.js"
        "*.routing.js"
        "*.component.js"
        "*.service.js"
        "*.map"
        ".DS_Store"
        ".vscode/"
        "node_modules/"
        "dist/"
        "bin/"
        ".tox/"
        ".mypy*/"
        "venv/"
        ".venv/"
        "__pycache__/"
      ];
    };
  };
}
