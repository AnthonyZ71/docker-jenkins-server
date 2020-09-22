FROM jenkins/jenkins:jdk11

## Configuration for Jenkins build pipelines

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -qqy \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
        apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" && \
    apt-get update  -qq && \
    apt-get install -y docker-ce && \
    usermod -aG docker jenkins && \
    apt-get clean

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
