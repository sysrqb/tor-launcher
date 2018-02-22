#!/bin/sh

TRANSLATION_BRANCHES="
tor-launcher-network-settings
tor-launcher-progress
tor-launcher-properties
"

if [ -d translation ];
then
  cd translation
  git fetch origin
  cd ..
else
  git clone https://git.torproject.org/translation.git
fi

cd translation
for branch in ${TRANSLATION_BRANCHES}
do
  git checkout ${branch}
  git merge origin/${branch}
  for locale in *
  do
    if [ ! -d "${locale}" ]
    then
      continue
    fi
    target="../../src/chrome/locale/$(echo "${locale}" | tr _ -)"
    # The en-US locale is "en" in transifex, but we need the files
    # available in en-US/ instead of en/.
    if [ "x${locale}" = "xen" ]
    then
      target="${target}-US"
    fi
    mkdir -p "${target}"
    cp -f "${locale}"/* "${target}"/
  done
done
