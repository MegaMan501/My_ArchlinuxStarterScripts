#!/bin/sh

sudo watch -n 1 "ss -4 -atunpH | column -t && echo && ss -6 -atunpH | column -t"
