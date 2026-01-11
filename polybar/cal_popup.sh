#!/bin/bash
# We use 'bash' inside the terminal to ensure the 'read' command works perfectly
alacritty --class "CalendarPopup" -e bash -c "cal; echo ''; echo '--- Press any key to close ---'; read -n 1"
