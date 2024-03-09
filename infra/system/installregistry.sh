#!/bin/sh
set -eux

CURR_ID=$(id -u)
[ "${CURR_ID}" != "0" ] && echo err: must run as root && exit 1

#BIN
set +u
set +e
HELM="$(command -v helm)"
[ -z "${HELM}" ] && echo "Helm not found" && exit 1
KUBECTL="$(command -v kubectl)"
[ -z "$KUBECTL" ] && echo "kubectl not found" && exit 1
set -e

# PATH
PATH_HELM_REG="helm/docker-registry"
PATH_HELM_MUSEUM="helm/chartmuseum"

# REGISTRY vars
REG_NS="registry"
REG_NAME="docker-registry"
# TODO pass to helm
# REG_PORT="30050"

# Museum vars
MUSEUM_NAME="chartmuseum"

HELM_MODE="install"
set -u

set +e
IS_NAMESPACE=$("${KUBECTL}" get ns "$REG_NS")
set -e
[ -z "${IS_NAMESPACE}" ] &&  echo "Namespace doesn't exist - creating it" && "${KUBECTL}" create ns "${REG_NS}"
set +e

echo Installing registry
[ ! -e "${PATH_HELM_REG}" ] && echo "helm repo for docker registry not found under ${PATH_HELM_REG}" && exit 1
"${HELM}" status  -n "$REG_NS" "$REG_NAME"
IS_HELM=$?
set -e
if [ "$IS_HELM" != "1" ]
then
  HELM_MODE="upgrade"
fi
"${HELM}" ${HELM_MODE} -n "${REG_NS}" --wait "$REG_NAME" "${PATH_HELM_REG}"

# POC local registry
# cat <<EOF > /etc/rancher/k3s/registries.yaml
#   mirrors:
#     docker.io:
#       endpoint:
#         - "http://127.0.0.1:${REG_PORT}"
# EOF
# systemctl daemon-reload && systemctl restart k3s

echo "Installing chartmuseum"
set +e
[ ! -e "${PATH_HELM_MUSEUM}" ] && echo "helm repo for docker registry not found under ${PATH_HELM_MUSEUM}" && exit 1
set -e
HELM_MODE="install"

set +e
"${HELM}" status  -n "$REG_NS" "$MUSEUM_NAME"
IS_HELM=$?
set -e

if [ "$IS_HELM" != "1" ]
then
  HELM_MODE="upgrade"
fi

"${HELM}" ${HELM_MODE} -n "${REG_NS}" --wait "$MUSEUM_NAME" "${PATH_HELM_MUSEUM}"
