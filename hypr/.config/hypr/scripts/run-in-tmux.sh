
session_name=$1
command=$2

tmux new-session -d -s $session_name "/bin/bash"

tmux send-keys -t$session_name "$command" Enter