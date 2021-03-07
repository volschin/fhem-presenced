#!/bin/bash
echo "Starte FHEM presenced"
rm -f /run/presenced.pid
exec /usr/bin/perl /presenced -v -p 5111
