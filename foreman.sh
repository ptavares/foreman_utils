#!/bin/bash

BASEDIR=$(dirname $0)

. ${BASEDIR}/functions.sh

USER=$(credential 'user')
PASS=$(credential 'pass')
FOREMAN_URL=$(config 'url')

function search_hosts {
    echo "Searching for hosts starting with ${1}..."
    FILTERS="search=${1}"
    HOSTS=$(get_result ${USER} ${PASS} ${FOREMAN_URL} ${FILTERS})
    echo ${HOSTS} | jq '.results[] | "\(.name)        \(.ip)"'
}


function all_hosts {
    echo "Lookup for all hosts..."
    NB_PAGE=1
    NB_CURRENT_HOSTS=0
    while true; do
        FILTERS="page=${NB_PAGE}"
        HOSTS=$(get_result ${USER} ${PASS} ${FOREMAN_URL} ${FILTERS})
        NB_HOSTS=$(echo ${HOSTS} | jq '.total')
        NB_HOSTS_PER_PAGE=$(echo ${HOSTS} | jq '.per_page')
        NB_PAGE_TO_SHOW=$(($NB_HOSTS/$NB_HOSTS_PER_PAGE))
        NB_PAGE_TO_SHOW=$((${NB_PAGE_TO_SHOW%.*}+1))
        echo ${HOSTS} | jq '.results[] | "\(.name)        \(.ip)"'
        NB_CURRENT_HOSTS=$(($NB_CURRENT_HOSTS+$NB_HOSTS_PER_PAGE))
        if [ $NB_CURRENT_HOSTS -gt $NB_HOSTS ]; then
            NB_CURRENT_HOSTS=$NB_HOSTS
        fi
        echo "${NB_CURRENT_HOSTS}/${NB_HOSTS} page (${NB_PAGE}/${NB_PAGE_TO_SHOW})"
        if [ ${NB_CURRENT_HOSTS} -eq ${NB_HOSTS} ]; then
            return 0
        fi
        read -n 1 -s -r -p "Press any key to continue"
        NB_PAGE=$(($NB_PAGE+1))
        next=
    done
}

case $1 in
    searchHosts)
        if [ $# -ne 2 ]; then
            echo "must specified starting host pattern"
            exit 1
        fi
        search_hosts $2
        ;;
    allHosts)
        all_hosts
        ;;
    *)
        echo "usage ${BASEDIR}/foreman_api.sh (searchHosts|allHosts)"
        ;;
esac

