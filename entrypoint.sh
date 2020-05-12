#!/bin/bash

echo "Starte FHEM presenced"
rm -f /run/presenced.pid
/usr/bin/perl /presenced -v -p 5111
