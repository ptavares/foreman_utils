#!/bin/bash

CREDENTIALS_FILE=~/.foreman/credentials
CONFIG_FILE=~/.foreman/config

function prop {
    grep "${1}" ${2}|cut -d'=' -f2
}

function credential {
    prop ${1} ${CREDENTIALS_FILE}
}

function config {
    prop ${1} ${CONFIG_FILE}
}

function get_result {
    USER=${1}
    PASS=${2}
    FOREMAN_URL=${3}
    FILTERS=${4}
    curl -s -H "Accept:application/json" -k -u ${USER}:${PASS} ${FOREMAN_URL}/api/hosts?${FILTERS}

}
