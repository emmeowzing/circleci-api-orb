#! /bin/bash
# Reduce nested commands and jobs to files under src/commands or src/jobs so they can be packed by 'circleci orb pack src/'.
# Allows you to group collections of commands under directories.

# Directory under which prepack directories reside.
SRC="${1:-src}"

# The subdirectory to prepack.
TYP="${2:-commands}"

pre-pack()
{
    current_directory="$1"

    cd "$current_directory" || exit 1

    find . -maxdepth 1 -mindepth 1 -type d -print0 | xargs --null -I % basename % | while read -r d; do
        pre-pack "$d"
        if [ -n "$(ls "${d}")" ]; then
            find "$d"/ -maxdepth 1 -mindepth 1 -type f -print0 | xargs --null -I % basename % | while read -r f; do
                fname="$(basename "$f")"
                if [ ! -f "${d}-${fname}" ]; then
                    cp "${f}" "${d}-${fname}"
                fi
            done
        elif [ -z "$(ls "${d}")" ]; then
            printf "INFO: Ignoring '%s', module is empty.\\n" "${SRC}/${TYP}/${d}"
        else
            printf "ERROR: Unhandled case.\\n" 1>&2
        fi
    done

    return 0
}

pre-pack "$SRC/$TYP/"
