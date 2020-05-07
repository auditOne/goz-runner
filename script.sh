#! /bin/bash

# Configuration
START_DELAY=0
TIMEOUT=5s
INTERVAL=88m
MAX_TRIES=2
COMMAND1=" rly tx raw update-client gameofzoneshub-1a your-chain-id xxxxxxxxx"
COMMAND2=" rly tx raw update-client your-chain-id gameofzoneshub-1a xxxxxxxxx"
TZ="UTC"

# Wait before starting
sleep $START_DELAY

# Handle failure
handle_failure() {
 # twilio curl request here for example to get a call on failure, change it to your preference
 curl 'https://api.twilio.com/2010-04-01/Accounts/XXXXXXXXXX/Calls.json' -X POST \
 --data-urlencode 'To=XXXXXXXXXX' \
 --data-urlencode 'From=XXXXXXXXX' \
 --data-urlencode 'Url=https://5eb3978953d2df8e6ee2ca95--eager-almeida-691675.netlify.app/voice.xml' \
 -u XXXXXXXXXXXXX:[AuthToken]

 printf "Made the call!\n"
}

# The runner
keep_running() {
 local COUNTER=1

 while true; do
  local x=$($1)

  local y=$(echo $x | jq .height)
  if [[ $y == '"0"' ]] || [[ $y == '' ]] ; then
    printf "$x\n\n$1 - Failure on attempt $COUNTER at `TZ=$TZ date`\n\n"
    COUNTER=$(($COUNTER+1))
    if [[ $COUNTER -gt $MAX_TRIES ]]; then
      break
    fi
    sleep $TIMEOUT
  else
    printf "$x\n\n$1 - Success on attempt $COUNTER at `TZ=$TZ date`\n\n"
    COUNTER=1
    sleep $INTERVAL
  fi
 done

 handle_failure
}

# The Invocation
keep_running "$COMMAND1" &
keep_running "$COMMAND2" &
wait