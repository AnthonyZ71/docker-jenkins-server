FROM jenkins/jenkins:centos7

## Configuration for Jenkins build pipelines

USER root

RUN \
    yum remove docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-engine && \
    yum install -y yum-utils && \
    yum-config-manager --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo && \
    yum install -y docker-ce-cli && \
    yum -y clean all && \
    rm -rf /var/cache/yum && \
    usermod -aG docker jenkins

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV PLUGINS_FORCE_UPGRADE=true

USER jenkins

RUN install-plugins.sh \
        anchore-container-scanner \
        bouncycastle-api \
        discord-notifier \
        docker \
        docker-workflow \
        github \
        sonar \
        workflow-multibranch

##

ARG BUILD_DATE
ARG IMAGE_NAME
ARG IMAGE_VERSION
LABEL build-date="$BUILD_DATE" \
      description="Image for Jenkins build pipeline" \
      summary="Base jenkins engine plus plugins." \
      name="$IMAGE_NAME"  \
      release="$IMAGE_VERSION" \
      version="$IMAGE_VERSION"
