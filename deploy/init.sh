tmux new-session -d -s "crystaltwin"
tmux setenv EXPLORER ${EXPLORER}
tmux setenv THREEBOT ${THREEBOT_ID}
tmux setenv SEED_PHRASE ${SEED_PHRASE}
tmux send-keys -t 0 "export THREEBOT_ID="$THREEBOT_ID C-m 
tmux send-keys -t 0 "export EXPLORER="$EXPLORER C-m 
tmux send-keys -t 0 "export SEED_PHRASE="$SEED_PHRASE C-m 
tmux split-window -h
tmux split-window -v
session=crystaltwin && window=${session}:0 && pane=${window}.0 && tmux send-keys -t "0" C-z '~/zdb/zdb --mode seq' Enter
session=crystaltwin && window=${session}:0 && pane=${window}.0 && tmux send-keys -t "1" C-z '~/bcdb/bcdb --meta ~/bcdb --threebot-id  ${THREEBOT_ID} --seed "${SEED_PHRASE}" --explorer ${EXPLORER}' Enter
~/crystaltwin/crystaltwin --threebot-id 40 --mnemonic "${SEED_PHRASE}" --explorer ${EXPLORER} --env production --secret fdlskds
