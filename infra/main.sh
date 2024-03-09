#!/bin/sh
set -eux

DEPS_SCRIPTS=system/installk3s system/installhelm system/installregistry ./system/kpack/installkpack
for DEP in $DEPS_SCRIPTS
do
  [ ! -e "${DEP}" ] && echo "not a valid install - couldn't find ${DEP}" && exit 1
done

install_system()
{
  ./system/install_k3s
  ./system/installhelm
  ./system/installregistry
  ./system/installkpack
}

