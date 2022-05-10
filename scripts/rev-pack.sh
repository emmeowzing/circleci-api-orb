#! /bin/bash
# Reverse operation of pre-pack.sh. If files exist with a prefix that matches a directory name, they'll be moved under 
# that directory, and the prefix removed.

# Directory under which revpack directories reside.
SRC="${1:-src}"

# The subdirectory to revpack.
TYP="${2:-commands}"

cd "$SRC/$TYP/" || exit 1

for directory in *; do
    if [ -d "${directory}" ] && [ -n "$(ls "${directory}")" ]; then
        for f in "${directory}"/*; do
            fname="$(basename "$f")"
            if [ ! -f "${directory}-${fname}" ]; then
                cp "${f}" "${directory}-${fname}"
            fi
        done
    elif [ -d "${directory}" ]; then
        printf "INFO: Ignoring '%s', module is empty.\\n" "${SRC}/${TYP}/${directory}"
    fi
done

cd - >/dev/null || exit 1
