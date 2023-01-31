#!/usr/bin/env zsh

set +x

# Colors
RED="\u001b[41;1m"
GREEN="\u001b[42;1m"
YELLOW="\u001b[43;1m"
BLUE="\u001b[44;1m"
MAGENTA="\u001b[45;1m"
NOCOLOR="\u001b[0m"

function title() {
    printf "\n${1}"
    printf '*%.0s' {1..$(expr ${#2} + 4)}
    printf "${NOCOLOR}\n${1}* ${2} *${NOCOLOR}\n${1}"
    printf '*%.0s' {1..$(expr ${#2} + 4)}
    printf "${NOCOLOR}\n\n"
}
function text() {
    printf "${1}"
}

function red_title() {
    title "${RED}" "${1}"
}

function green_title() {
    title "${GREEN}" "${1}"
}

function yellow_title() {
    title "${YELLOW}" "${1}"
}

function blue_title() {
    title "${BLUE}" "${1}"
}

function magenta_title() {
    title "${MAGENTA}" "${1}"
}

function yellow_text() {
    text "${YELLOW}" "${1}"
}