
amount=-10
command="movetoworkspace"
wrap=0

if [ "$1" != "" ]
then
    amount=$1
fi

if [ "$2" == "onlychangeworkspace" ]
then
    command="workspace"
fi

if [ "$3" == "wrap" ]
then
    wrap=1
fi

active_workspace_id=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .activeWorkspace | .id')

workspace_id=$(echo "$active_workspace_id $amount" | bc)

if [ $wrap -eq 1 ]
then

    if [[ $workspace_id == -* ]]
    then
        monitor=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .id')
        target_workspace=$(hyprctl workspaces -j | jq ".[] | select(.monitorID == $monitor) | .id" | tail -1)
        amount="$target_workspace"
        workspace_id="$target_workspace"S
    fi

    exists=$(hyprctl workspaces -j | jq ".[] | select(.id == $workspace_id) | .id")
    if [ "$exists" == "" ]
    then
        offset_amount="$(echo "(($active_workspace_id / 10) * 10)" | bc)"
        workspace_id="$(echo "$active_workspace_id - $offset_amount" | bc)"
    fi
fi

if [[ $workspace_id == -* ]]
then
    echo "Can't decrement"
else
    if [[ $(hyprctl workspaces -j | jq ".[] | select(.id==$active_workspace_id) | .windows") == 0 ]]
    then
        command="workspace"
    fi
    hyprctl dispatch $command $workspace_id
fi