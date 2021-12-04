#!/bin/bash

fennel=./fennel-0.8.1

redo-ifchange "$2.fnl"

lua "$fennel" --compile "$2.fnl"
