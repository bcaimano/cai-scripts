#!/bin/bash

COMMAND="$1"
sudo systemctl "$COMMAND" iceccd.service
