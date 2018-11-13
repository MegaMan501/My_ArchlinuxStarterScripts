#!/bin/sh

youtube-dl -g --no-warnings "$1" | vlc -
