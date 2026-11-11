#if command -q fastfetch; and test "$TERM_PROGRAM" != vscode; and not set -q TMUX
	#    fastfetch
    #end
# --- env (cheap, also useful for non-interactive shells) ---
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx LESS -RFX
fish_add_path -g ~/.local/bin ~/.cargo/bin

status is-interactive; or return

# --- basics ---
set -g fish_greeting
set -g fish_history_max 20000 2>/dev/null

# --- cached tool init: runs the tool once, then just sources a file ---
function __cached_init
    set -l tool $argv[1]
    set -l bin (command -s $tool); or return
    set -l f ~/.cache/fish-init-$tool.fish
    if not test -f $f; or test $f -ot $bin   # regenerate after upgrades
        mkdir -p ~/.cache
        $bin $argv[2..] >$f
    end
    source $f
end

__cached_init zoxide init fish --cmd cd      # smart cd: `cd proj`
__cached_init fzf --fish                     # Ctrl+R history, Ctrl+T files, Alt+C dirs

set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"
if command -q fd
    set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --exclude .git"
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
end

# --- abbreviations (expand on screen, full command lands in history) ---
if command -q eza
    abbr -a ls eza --group-directories-first
    abbr -a ll eza -l --git --group-directories-first
    abbr -a la eza -la --git --group-directories-first
    abbr -a lt eza --tree --level=2
else
    abbr -a ls ls --color=auto --group-directories-first
    abbr -a ll ls -lh --color=auto
end

abbr -a gs git status -sb
abbr -a ga git add
abbr -a gc git commit
abbr -a gp git push
abbr -a gd git diff
abbr -a gl git log --oneline --graph --decorate

abbr -a pacu sudo pacman -Syu
abbr -a pac  sudo pacman -S
abbr -a pacs pacman -Ss
abbr -a pacr sudo pacman -Rns
abbr -a dc   docker compose
abbr -a ..   cd ..
abbr -a ...  cd ../..

# --- prompt: pure fish, git info only inside a repo ---
set -g __fish_git_prompt_show_informative_status 0
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_char_dirtystate '*'

function fish_prompt
    set -l last $status
    set -l dur $CMD_DURATION

    set_color brblue
    echo -n (prompt_pwd)
    set_color brblack
    echo -n (fish_vcs_prompt)

    if test $dur -gt 3000
        set_color yellow
        echo -n " "(math --scale 0 $dur / 1000)s
    end

    if test $last -ne 0
        set_color red
        echo -n " [$last]"
    end

    set_color $(test $last -eq 0; and echo green; or echo red)
    echo -n ' ❯ '
    set_color normal
end

function fish_right_prompt; end   # no right prompt
