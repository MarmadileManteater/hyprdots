#!/bin/bash

SHORT_HELP="$1"
HELP_ARGS="$2"

if [ "$(echo "$@" | grep '\--help-short' -o)" != "" ]
then
  echo "$SHORT_HELP"
  exit
fi

if [ "$(echo "$@" | grep '\--help' -o)" != "" ]
then
  echo "$SHORT_HELP"
  echo -e "$HELP_ARGS"
  exit
fi

echo ""