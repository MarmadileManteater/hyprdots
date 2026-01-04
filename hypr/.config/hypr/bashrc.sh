export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_QUICK_CONTROLS_STYLE="qt5ct"

# for quick access
export FORCE_WAYLAND_CHROME_ARGS="--enable-features=UseOzonePlatform --ozone-platform=wayland"
# since i'm always launching it like this
alias wfreetube="freetube $FORCE_WAYLAND_CHROME_ARGS"
alias set-bg="$HOME/.config/hypr/scripts/set-background.sh"
alias set-accent="$HOME/.config/hypr/scripts/set-accent-color.sh"
alias accent-options="$HOME/.config/hypr/scripts/change-accent-from-wallpaper.sh"
alias get-accent="$HOME/.config/hypr/scripts/get-accent-color.sh"

PATH="/mnt/personal/workspace/scripts-toolbox/linux/:$PATH"

USING_GNOME=0

if [ "$(fastfetch | grep "DE: GNOME")" != "" ]
then
    USING_GNOME=1
fi

if [[ "$(ps -p $(ps -p $$ -o ppid=) -o args=)" == *"ptyxis"* ]]
then
    if [[ "$USING_GNOME" == "0" ]]
    then
        # hacky, but it does work
        tmux kill-session -tkitty
        # opens kitty instead of ptyxis
        $HOME/.config/hypr/scripts/run-in-tmux.sh kitty "kitty '$(pwd)'"
        kill $(ps -p $$ -o ppid=)
    fi
fi

function fix-iron-bar-shortcuts() {
    sudo bash $HOME/.config/hypr/scripts/fix-ironbar-shortcuts.sh org.mozilla.firefox kitty codium freetube
}