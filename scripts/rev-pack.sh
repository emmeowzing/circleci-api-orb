#! /bin/bash
# Reverse operation of pre-pack.sh. If files exist with a prefix that matches a directory name, they'll be moved under 
# that directory, and the prefix removed.

# Directory under which revpack directories reside.
SRC="${1:-src}"

# The subdirectory to revpack.
TYP="${2:-commands}"

cd "$SRC/$TYP/" || exit 1

find . -maxdepth 1 -mindepth 1 -type f -print0 | xargs --null -I % basename % | while read -r f; do 
    subdir="$(echo "$f" | awk -F '-' '{ print $1 }')"
    if [ -n "$(ls "$subdir")" ]; then
        fname="${f##"$subdir"-}"
        if [ -f "${subdir}/${fname}" ]; then
            if [ "$(md5sum "$f")" = "$(md5sum "${subdir}/${fname}")" ]; then
                printf "Removing '%s'.\\n" "$f"
                # shellcheck disable=SC2216
                yes | rm "$f"
            else
                printf "'%s' exists in '%s', but checksums don't match. Skipping removal.\\n" "$fname" "$subdir"
            fi
        else
            printf "'%s' does not exist in '%s'.\\n" "$fname" "$subdir"
        fi
    else
        printf "Skipping '%s' as the subdirectory '%s' is empty.\\n" "$f" "${subdir}/\\n"
    fi
done

cd - >/dev/null || exit 1
