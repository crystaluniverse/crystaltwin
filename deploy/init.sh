tmux new-session -d -s "crystaltwin"
tmux split-window -h
tmux split-window -v
session=crystaltwin && window=${session}:0 && pane=${window}.0 && tmux send-keys -t "0" C-z '~/zdb/zdb --mode seq' Enter
session=crystaltwin && window=${session}:0 && pane=${window}.0 && tmux send-keys -t "1" C-z '~/bcdb/bcdb --meta ~/bcdb --threebot-id  ${THREEBOT_ID} --seed ${SEED} --explorer ${EXPLORER}' Enter
session=crystaltwin && window=${session}:0 && pane=${window}.0 && tmux send-keys -t "2" C-z '~/crystaltwin/crystaltwin --threebot-id ${THREEBOT_ID} --mnemonic ${SEED} --explorer ${EXPLORER} --env production' Enter
tmux attach