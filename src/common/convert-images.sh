#!/usr/bin/env bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# ==== COMMENTARY ====

# Automatically convert the contents of the source image folder to optimized webps with a max resolution of 1024x768.

# TODO: convert this to be mostly elisp.

# REQUIRES: awk, GNU coreutils, bash, GNU findutils, imagemagick

# ==== CODE ====

set -euo pipefail

pushd "$(dirname "${0}")"'/../images/'

if [[ ! -d ../../docs/images ]]; then
    printf "creating image output directory"
    mkdir ../../docs/images
fi

while IFS= read -r -d '' file; do
    outfile="../../docs/images/${file%.*}"'.webp'

    if [[ -f $outfile ]]; then
        printf "%s already exists in output folder, skipping\n" "${outfile}"
        continue
    fi

    metadata="$(identify -format '%w %h %m\n' "${file}")"
    printf "%s metadata: %s\n" "${file}" "${metadata}"
    width="$(awk '{print $1}' <<< "${metadata}")"
    height="$(awk '{print $2}' <<< "${metadata}")"
    type="$(awk '{print $3}' <<< "${metadata}")"

    # 786432 = 1024 * 768
    if [[ $((width * height)) -gt 786432 && "${type}" != 'WEBP' ]]; then
        printf "converting and copying %s\n" "${file}"
        magick "${file}" -resize '786432@' "${outfile}"
    else
        printf "copying %s verbatim, it is already correct\n" "${file}"
        cp "${file}" "${outfile}"
    fi
done < <(find . -type f -regextype posix-extended -iregex '.*\.(jpe?g|png|gif|bmp|webp|tiff)$' -print0)

popd
