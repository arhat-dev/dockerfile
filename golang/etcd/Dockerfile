# Reference
# https://github.com/etcd-io/etcd/blob/main/Dockerfile-release.amd64
RUN set -eux ;\
    echo \
    'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' \
    >>/etc/nsswitch.conf
