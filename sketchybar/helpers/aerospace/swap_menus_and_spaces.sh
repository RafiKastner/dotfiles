#!/usr/bin/env bash

sketchybar --trigger swap_menus_and_spaces NEW_STATE=$(if [ $(sketchybar --query space_number.1 | jq -r ".geometry.drawing") == "on" ]; then echo menus; else echo spaces; fi)
