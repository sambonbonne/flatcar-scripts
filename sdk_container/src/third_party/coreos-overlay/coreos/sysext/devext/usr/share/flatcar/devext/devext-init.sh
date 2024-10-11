#!/bin/bash

set -euo pipefail

version="$(source /usr/lib/extension-release.d/extension-release.devext \
           && echo "VERSION_ID")"

basedir="/usr/share/flatcar/devext"
vardir="/var/devext/${version}"

for dir in var/db/pkg \
           var/lib/portage \
           etc/portage; do

    workdir="${vardir}/.$(basename "${dir}")-work"
    writedir="${vardir}/${dir}"
    mkdir -p "/${dir}" "${writedir}" "${workdir}"

    # TODO: move to mount units?
    srcdir="${basedir}/${dir}"
    mount -t overlay \
        -o "lowerdir=${srcdir},upperdir=${writedir},workdir=${workdir}" \
        "/usr/share/flatcar/devext/${dir}" "/${dir}"
done
