#! /bin/bash
# Reverse operation of pre-pack.sh. If files exist with a prefix that matches a directory name, they'll be moved under 
# that directory, and the prefix removed.

# Directory under which revpack directories reside.
SRC="${1:-src}"

# The subdirectory to revpack.
TYP="${2:-commands}"

rev-pack()
{
    current_directory="$1"

    cd "$current_directory" || exit 1

    find . -maxdepth 1 -mindepth 1 -type f -print0 | xargs --null -I % basename % | while read -r f; do
        subdir="$(echo "$f" | awk -F '-' '{ print $1 }')"
        if [ -d "$subdir" ] && [ -n "$(ls "$subdir")" ]; then
            fname="${f##"$subdir"-}"
            # Only remove the file if it has an exact matching counterpart in the subdirectory.
            if [ -f "${subdir}/${fname}" ]; then
                if [ "$(md5sum "$f" | awk '{ print $1 }')" = "$(md5sum "${subdir}/${fname}" | awk '{ print $1 }')" ]; then
                    printf "Removing '%s'.\\n" "$f"
                    # shellcheck disable=SC2216
                    yes | rm "$f"
                else
                    printf "'%s' exists in '%s', but checksums don't match. Skipping removal.\\n" "$fname" "$subdir"
                fi
            else
                printf "'%s' does not exist in '%s'.\\n" "$fname" "$subdir"
            fi
        elif [ -d "$subdir" ] && [ -z "$(ls "$subdir")" ]; then
            printf "Skipping '%s' as the subdirectory '%s' is empty.\\n" "$f" "${subdir}/"
        else
            :
        fi
    done

    find . -maxdepth 1 -mindepth 1 -type d -print0 | xargs --null -I % basename % | while read -r d; do
        rev-pack "$d"
    done

    cd ..

    return 0
}

rev-pack "$SRC/$TYP/"
