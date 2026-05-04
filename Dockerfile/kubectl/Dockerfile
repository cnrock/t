FROM --platform=$TARGETPLATFORM container-registry.oracle.com/os/oraclelinux:10-slim
LABEL MAINTAINER Wan Jie <webmaster@wanjie.info>

ARG ARCH=amd64
ARG KUBERNETES_RELEASE=v1.35.0

# 设置环境变量
ENV TZ=Asia/Shanghai
ENV POD_NAMESPACE=default
ENV HOME=/home/kubectl

# 安装必要软件
RUN microdnf update -y && \
    microdnf install -y curl vim bash-completion tzdata && \
    microdnf clean all

# 设置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

# 下载kubectl - 使用新的官方地址
WORKDIR /tmp
RUN echo "Downloading kubectl ${KUBERNETES_RELEASE} for ${ARCH}..." && \
    curl -fsSLO "https://dl.k8s.io/release/${KUBERNETES_RELEASE}/bin/linux/${ARCH}/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    echo "Download completed successfully"

# 验证 kubectl 下载
RUN /usr/local/bin/kubectl version --client --output=yaml || echo "Kubectl version check completed"

# 创建用户
RUN useradd -u 1000 -U -m kubectl

# 配置bash环境
USER kubectl
WORKDIR /home/kubectl

RUN echo 'source <(/usr/local/bin/kubectl completion bash)' >> .bashrc && \
    echo 'alias k=kubectl' >> .bashrc && \
    echo 'complete -o default -F __start_kubectl k' >> .bashrc && \
    echo "export POD_NAMESPACE='default'" >> .bashrc && \
    echo "export TZ=Asia/Shanghai" >> .bashrc && \
    echo "export POD_NAMESPACE='default'" > .env

# 设置默认命令
ENTRYPOINT ["/usr/local/bin/kubectl"]
CMD ["help"]
