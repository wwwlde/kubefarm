#!/bin/sh
# The script generates commands to perform etcd backup for the kubefarm's cluster
#
# Example usage:
#   ./etcd-backup.sh cluster1-kubernetes-etcd-0 snapshot.db
#
# where:
#   - cluster1-kubernetes-etcd-0: name of your etcd pod
#   - snapshot.db: filename to save backup locally

set -e
if [ $# -lt 2 ]; then
  echo "USAGE: $(basename $0) <etcd_pod> <file>"
  exit 1
fi

cat <<EOT

# perform backup
kubectl exec "$1" -- sh -c 'ETCDCTL_ENDPOINTS= etcdctl snapshot save /snapshot.db'

# download file
kubectl cp "$1:/snapshot.db" "$2"

# remove remote copy
kubectl exec "$1" -- sh -c 'rm -fv /snapshot.db'

EOT
