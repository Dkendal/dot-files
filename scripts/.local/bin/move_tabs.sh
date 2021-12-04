#!/bin/bash
if test -n "$(find . -maxdepth 1 -name '~/Downloads/*.gp*' -print -quit)"
then
    mv ~/Downloads/*.gp* ~/Downloads/tabs/
fi
