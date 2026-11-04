#!/bin/sh
# no argument: print level for waybar; "up" / "down": change by 1%
dev=intel_backlight

case "$1" in
  up)   brightnessctl -d $dev set 1%+ >/dev/null; pkill -RTMIN+9 waybar; exit 0 ;;
  down) brightnessctl -d $dev -n 1 set 1%- >/dev/null; pkill -RTMIN+9 waybar; exit 0 ;;
esac

pct=$(brightnessctl -d $dev -m | cut -d, -f4 | tr -d '%')

if   [ "$pct" -ge 80 ]; then cls=l5
elif [ "$pct" -ge 60 ]; then cls=l4
elif [ "$pct" -ge 40 ]; then cls=l3
elif [ "$pct" -ge 20 ]; then cls=l2
else cls=l1
fi

echo "{\"text\":\"bri ${pct}%\",\"class\":\"$cls\"}"
