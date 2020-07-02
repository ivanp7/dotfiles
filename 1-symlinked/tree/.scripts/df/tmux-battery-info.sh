#!/bin/sh

DELIMITER=$1

acpi -b 2> /dev/null | sed -E "
s/^Battery /bat/; s/ remaining\$//; s/ at zero rate.*//;
s/Discharging,/↓/; s/Charging,/↑/; s/Unknown, //;
s/ ([0-9]+%), (\S+)/ \1 \(\2\)/;
s/^/ /; s/\$/ $DELIMITER/" | tr -d '\n' | sed "s/^  $DELIMITER\$//"

