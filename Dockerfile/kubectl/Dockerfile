FROM  container-registry.oracle.com/os/oraclelinux:9-slim AS build
LABEL MAINTAINER Wan Jie <webmaster@wanjie.info>

ARG ARCH
ARG KUBERNETES_RELEASE=v1.25.4
WORKDIR /bin
RUN set -x \
 && curl -fsSLO https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_RELEASE}/bin/linux/${ARCH}/kubectl \
 && chmod +x kubectl
RUN useradd -u 1000 -U -m kubectl

FROM scratch
COPY --from=build /bin/kubectl /bin/kubectl
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group
USER kubectl
ENTRYPOINT ["/bin/kubectl"]
CMD ["help"]
