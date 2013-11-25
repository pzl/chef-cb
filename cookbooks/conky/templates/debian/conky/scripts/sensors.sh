#!/bin/bash
cat ~/.config/conky/output/sensors.txt | grep temp.*_input | tail -n +2 | head -4 | sed 's/.* //' | sed 's/\..*//' | tr '\n' 'C' | sed 's/C/C | /g' | cut -c 1-21
