{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fish

    # file searching and manipulation
    bat
    delta
    eza
    fzf
    grc
    jless
    jq
    ripgrep
    yq-go

    # misc
    bemenu
    bingrep
    broot
    dutree
    feh
    grex
    ranger
    skim

    # system
    bottom
    btop
    iotop
    iftop
    procs
    fd
    dysk
    killall
    strace
    ltrace
    lsof
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
  ];

  home.shellAliases = {
    # ls
    ls = "eza -g";
    x = "eza";
    tree = "eza --tree";
    l = "ls";
    ll = "ls -lh";
    la = "ls -a";
    lla = "ls -lha";
    left = "ls -t -1";

    # cd
    cd = "z";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    cdgt = "pushd `git rev-parse --show-toplevel`";

    bench = "hyperfine";
    top = "btm";
    htop = "btm";

    pvea = ". ./.venv/bin/activate";

    gta = "go test ./...";

    du = "dust";
    cat = "bat";
    grep = "rg -i";
    cloc = "tokei";
    ps = "procs";

    # git abbreviations
    gA = "git add -A";
    gP = "git push -f";
    gb = "git branch";
    gbd = "git branch --delete";
    gcm = "git commit -m";
    gco = "git checkout";
    gcob = "git checkout -b";
    gp = "git push --follow-tags";
    gpom = "git push origin main";
    gst = "git stash";
    gstp = "git stash pop";
    ga = "git add";
    gbc = "git rev-parse --abbrev-ref HEAD";
    gbs = "git show-branch";
    gc = "git commit -s -m";
    gca = "git commit -s --amend";
    gcane = "git commit -s --amend --no-edit";
    gcanv = "git commit -s --amend --no-verify";
    gcav = "git commit -s --amend --verify";
    gcnv = "git commit -s --no-verify -m";
    gcv = "git commit -s --verify -m";
    gd = "git diff";
    gdl = "gd HEAD~1";
    gds = "git diff --staged";
    gdt = "git difftool";
    gdtl = "gdtool HEAD~1";
    gdts = "git difftool --staged";
    gg = "git grep";
    gk = "gitk --all";
    gl = "glog -10";
    glog = "git log --pretty=format:\"%C(yellow)%h %C(cyan)%<(24)%ad %Cgreen%an%C(auto)%d%Creset: %s\" --date=local";
    gm = "git merge --ff-only --no-verify";
    gmt = "git mergetool";
    gpu = "git pull --rebase";
    gr = "git rebase";
    gra = "git rebase --abort";
    grc = "git rebase --continue";
    gri = "git rebase -i";
    gs = "git status -b --show-stash -M --ahead-behind";
    gsta = "git stash apply";
    gstcl = "git stash clear";
    gstd = "git stash drop";
    gstl = "git stash list --pretty=format:\"%C(red)%<(10)%gd %C(yellow)%h %C(cyan)%<(13)%cr %Cgreen%an%C(auto)%d%Creset: %s\"";
    gsts = "git stash show";
    gu = "git add -u";

    # k8s
    kc = "kubectl";

    r = "ranger";
  };

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
    ];

    shellAbbrs = {
      edit = "nvim";

      # k8s
      kc = "kubectl";

      # python
      pvea = ". ./.venv/bin/activate";
    };

    functions = {
      gcf = ''
        function gcf {
          if [[ -z "$1" ]]; then
              echo "Commit hash to fixup is missing"
              return 1
          fi

          git commit --fixup="$1"
          git rebase -i --autosquash "$1"~1
        }
      '';

      fish_greeting = {
        description = "Greeting when starting the fish shell";
        body = "";
      };
    };
  };

  programs.zoxide.enable = true;
}