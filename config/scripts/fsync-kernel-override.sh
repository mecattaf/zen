#!/usr/bin/env bash

set -oue pipefail

echo 'fsync kernel override'
rpm-ostree cliwrap install-to-root
rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra --install kernel-fsync

#rpm-ostree override replace --experimental --from repo='copr:copr.fedorainfracloud.org:sentry:kernel-fsync' \
#kernel \
#kernel-core-* \
#kernel-modules-* \
#kernel-uki-virt-*
