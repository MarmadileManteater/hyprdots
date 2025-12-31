

session_name=$1
command=$2
flags=$3

tmux new-session -d -s $session_name "/bin/bash"

tmux send-keys -t$session_name "$command" Enter

if [[ "$flags" == "-"* ]]
then
    if [[ "$flags" == *"a"* ]]
    then
        tmux attach-session -t$session_name
    fi
fi