#!/usr/bin/env bash

DIR=$HOME/pictures/wallpapers
PICS=($(ls ${DIR}))

RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

if [[ $(pidof swaybg) ]]; then
  pkill swaybg
fi

swaybg -m fill -i ${DIR}/${RANDOMPICS}
canberra-gtk-play -i window-attention
