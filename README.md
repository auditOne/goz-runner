# GoZ Relayer auto-update runner

I have made an automated script to update the relayer clients with tunable config, error handling and failure handling. Its been working for me very well, but I can't assure it handles every case

Please  make a pull request if have any feature additions. But it shouldn't make the script less reliable than it is right now. Thanks :)

## Quick Start

1. Update commands in `script.sh`. Use `docker-compose exec -T` in case you are running via docker-compose.

```bash
COMMAND1=" rly tx raw update-client gameofzoneshub-1a your-chain-id xxxxxxxxx"
COMMAND2=" rly tx raw update-client your-chain-id gameofzoneshub-1a xxxxxxxxx"
```
2. Run the script

```bash
bash script.sh
```

You can see the output for the first run. Now sleep easy during GoZ ;)


## How to use

1. Update the config section and handle failure to your preference

    **START_DELAY** - How long to wait before first run. Useful if you've already run the commands recently

    **TIMEOUT** - How long to wait before retrying a command

    **INTERVAL** - What is the interval between success runs. For GoZ, something like 88m is ideal

    **MAX_TRIES** - Maximum failed attempts before it gives up calls you

    **COMMAND1** - Command to update your relayer client 1. Use `docker-compose exec -T` when using docker-compose exec

    **COMMAND2** - Command to update your relayer client 1

    **TZ** - Timezone for logging time

    **Important:** My handle_failure function calls me on failure using twilio voice API so that I can look into it. You can sign up for free or do something else here to be notified via slack, email, etc. 

    But do not run without this as you have no way to know if something has failed

2. Run the script in tmux or use something like systemd to keep it running

    > $ ./script.sh


## How it works

It runs the two commands in a loop

> rly tx raw update-client chain-id-1 chain-id-2 client-id-src

and 

> rly tx raw update-client chain-id-2 chain-id-1
client-id-dst

and uses `jq` to parse the output

If there is an error or the height value is 0 in the response, it considers it a failed response

On failure it gives a TIMEOUT and runs it again till MAX_TRIES

if it still failes, it will hanlde failure and halt

## Fearures to be added

- Check balance on each run and handle low balance (Feel free to make a PR)

## Contact

- You can reach me on telegram with id @sub4sh or email me at subash@audit.one
