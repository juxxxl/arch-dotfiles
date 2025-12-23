#!/bin/bash

if pgrep -x "gjs" > /dev/null; then
    pkill gjs
else
    ags run &
fi

