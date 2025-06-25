#!/bin/bash
set -e

BITCOIN_DIR="/home/student/.bitcoin"
CONFIG_PATH="$BITCOIN_DIR/bitcoin.conf"

mkdir -p "$BITCOIN_DIR"
chown -R student:student "$BITCOIN_DIR"

if [ ! -f "$CONFIG_PATH" ]; then
    cp /etc/bitcoin.conf "$CONFIG_PATH"
    chown student:student "$CONFIG_PATH"
fi

# Default to bash if no command was passed
if [ $# -eq 0 ]; then
    set -- bash
fi

exec gosu student "$@"
