#!/bin/sh
# no argument: print current profile for waybar; "next": cycle to the next one
cur=$(powerprofilesctl get)

if [ "$1" = "next" ]; then
  case "$cur" in
    power-saver) powerprofilesctl set balanced ;;
    balanced)    powerprofilesctl set performance 2>/dev/null || powerprofilesctl set power-saver ;;
    *)           powerprofilesctl set power-saver ;;
  esac
  exit 0
fi

case "$cur" in
  power-saver) echo '{"text":"pwr saver","class":"saver"}' ;;
  balanced)    echo '{"text":"pwr balanced","class":"balanced"}' ;;
  performance) echo '{"text":"pwr perf","class":"perf"}' ;;
  *)           echo '{"text":"pwr ?","class":""}' ;;
esac
