
amount=-10

if [ "$1" != "" ]
then
    amount=$1
fi

active_workspace_id=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .activeWorkspace | .id')
echo "$active_workspace_id $amount"
workspace_id=$(echo "$active_workspace_id $amount" | bc)
if [[ $workspace_id == -* ]]
then
    echo "Can't decrement"
else
    command="movetoworkspace"
    if [[ $(hyprctl workspaces -j | jq ".[] | select(.id==$active_workspace_id) | .windows") == 0 ]]
    then
        command="workspace"
    fi
    hyprctl dispatch $command $amount
fi