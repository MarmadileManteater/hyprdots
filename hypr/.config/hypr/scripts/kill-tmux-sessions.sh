
exclude=0

if [[ "$*" == *" --exclude "* || "$*" == *" --exclude" ]]
then
    exclude=1
fi

session_names=$(tmux list-sessions | grep -o '.*: ' | cut -d ':' -f 1)


if [ $exclude == 0 ]
then
    for session_name in "$@"
    do
        tmux kill-session -t$session_name
    done
else
    set -o noglob
    IFS=$'\n' list_session_names=($session_names)
    set +o noglob
    for session_name in "${list_session_names[@]}"
    do
        if [[ "$@" == *"$session_name"* ]]
        then
            continue
        fi
        tmux kill-session -t$session_name
    done
fi