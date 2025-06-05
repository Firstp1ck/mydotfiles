#!/usr/bin/env bash

# Get battery information
charge=$(razer-cli --battery "Razer Naga Pro V2" | grep 'charge:' | awk '{print $2}')
charging=$(razer-cli --battery "Razer Naga Pro V2" | grep 'charging:' | awk '{print $2}')

# Choose icon based on charge level
if [ "$charge" -ge 80 ]; then
    icon=""
elif [ "$charge" -ge 60 ]; then
    icon=""
elif [ "$charge" -ge 40 ]; then
    icon=""
elif [ "$charge" -ge 20 ]; then
    icon=""
else
    icon=""
fi

# Add charging indicator
if [ "$charging" = "True" ]; then
    charging_icon=""
else
    charging_icon=""
fi

# Format output with DPI
echo "$icon $charge% $charging_icon"