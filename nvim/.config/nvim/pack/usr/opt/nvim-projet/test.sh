#!/bin/sh
# ./lua_modules/bin/busted $@

nvim -nm --headless +"lua require'projet-test'" +"q!" $@ 2>&1
