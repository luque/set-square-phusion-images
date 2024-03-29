#!/bin/bash

_namespace="$(head -n 1 /Dockerfiles/Dockerfile | sed 's_^#\s\+__g' | cut -d'/' -f 1)";
_image="$(head -n 1 /Dockerfiles/Dockerfile | sed 's_^#\s\+__g' | cut -d'/' -f 2 | cut -d':' -f 1)";
_tag="$(head -n 1 /Dockerfiles/Dockerfile | sed 's_^#\s\+__g' | cut -d'/' -f 2 | cut -d':' -f 2 | cut -d' ' -f 1)";

cat <<EOF
${_namespace}/${_image}:${_tag}
EOF
cat /Dockerfiles/copyright-preamble.txt

[ -f /README ] && NAMESPACE="${_namespace}" IMAGE="${_image}" TAG="${_tag}" envsubst '${NAMESPACE} ${IMAGE} ${TAG}' < /README

cat <<EOF

This image was generated with set-square:
https://github.com/rydnr/set-square

The Dockerfiles used to build this image can be inspected.
This Dockerfile:
> docker run -it ${_namespace}/${_image}:${_tag} Dockerfile
or 
> docker run -it ${_namespace}/${_image}:${_tag} Dockerfile ${_namespace}-${_image}.${_tag}
Its parents (in order):
EOF

for d in \
    $(  ls -t /Dockerfiles/* \
      | grep -v -e '^/Dockerfiles/copyright-preamble.txt$' \
      | grep -v -e '^/Dockerfiles/Dockerfile$' \
      | grep -v -e "^/Dockerfiles/${_namespace}-${_image}\.${_tag}$"); do
  echo "> docker run -it ${_namespace}/${_image}:${_tag} Dockerfile $(basename $d)";
done
