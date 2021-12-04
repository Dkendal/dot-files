#!/bin/bash
redo-sources | grep '^[^\.\.]' | entr -c redo -dxv
