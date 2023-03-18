#!/usr/bin/env bash

HIGHEST_FREE=0

get_best_gid() {
    GID_RANGE=( {100..999} )
    # see http://www.bashoneliners.com/oneliners/275/
    mapfile -t LOCAL_GIDS < <(sort -t':' -nk3,3 /etc/group |cut -d: -f 3)
    if [ "${#LOCAL_GIDS}" -eq 0 ];then echo "unable to get local group gids. exiting";exit 1;fi
    for gid in "${GID_RANGE[@]}"; do
        [[ " ${LOCAL_GIDS[@]} " =~ " ${gid} " ]] && continue || HIGHEST_FREE="$gid"
    done
}

# see http://www.bashoneliners.com/oneliners/275/
mapfile -t FIX_GROUPS < <(grep ":999:" /etc/group | sort -t':' -nk3,3 |cut -d: -f 1)
if [ "${#FIX_GROUPS[@]}" -eq 0 ];then
    echo "no local group 999 to fix. exiting"
    exit 0
fi

for group in "${FIX_GROUPS[@]}"; do
    if [ "$group" == "g999" ];then
        continue
    fi
    get_best_gid
    lgroupmod -g "$HIGHEST_FREE" "$group"
done

if (grep ":999:" /etc/group);then
    echo "failed to modify local gid 999 groups"
    exit 1
fi
    
