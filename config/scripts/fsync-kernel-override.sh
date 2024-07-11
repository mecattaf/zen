#!/usr/bin/env bash

set -oue pipefail

echo 'fsync kernel override'
#rpm-ostree cliwrap install-to-root / && \
#rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra --install kernel-cachyos-lto    
rpm-ostree cliwrap install-to-root
wget https://copr.fedorainfracloud.org/coprs/sentry/kernel-fsync/repo/fedora-${OS_VERSION}/sentry-kernel-fsync-fedora-${OS_VERSION}.repo -O /etc/yum.repos.d/_copr_kernel-fsync.repo
rpm-ostree override replace --experimental --from repo='copr:copr.fedorainfracloud.org:sentry:kernel-fsync' \
kernel \
kernel-core-* \
kernel-modules-* \
kernel-uki-virt-*
