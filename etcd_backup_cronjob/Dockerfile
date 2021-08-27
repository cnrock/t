From 10.23.101.18/kube-system/dce-etcd:3.4.1.1
Workdir /tmp

ENV etcd_backup_save_dir=/nfs \
etcd_backup_temp_dir=/tmp \
ETCDCTL_ENDPOINTS="https://127.0.0.1:12379"

# etcdctl v2 version
ENV ETCDCTL_CACERT=/etc/ssl/private/ca.crt \
ETCDCTL_CA_FILE=/etc/ssl/private/ca.crt \
ETCDCTL_CERT_FILE=/etc/ssl/private/etcd/peer.crt

# etcdctl v3 version
ENV ETCDCTL_CERT=/etc/ssl/private/etcd/peer.crt \
ETCDCTL_KEY_FILE=/etc/ssl/private/etcd/peer.key \
ETCDCTL_KEY=/etc/ssl/private/etcd/peer.key

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+x /docker-entrypoint.sh
Entrypoint "/docker-entrypoint.sh"
