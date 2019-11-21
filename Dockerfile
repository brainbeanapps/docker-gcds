FROM centos:7

LABEL maintainer="infrastructure@brainbeanapps.com"

# Install updates, enable EPEL, install dependencies
RUN yum -y update && \
  yum -y install epel-release && \
  yum -y install ca-certificates curl gzip which java-1.8.0-openjdk && \
  yum clean all && \
  rm -rf /var/cache/yum

# Download and install Google Cloud Directory Sync
WORKDIR /opt/gcds
RUN curl -fsSLo /tmp/dirsync-install.sh https://dl-ssl.google.com/dirsync/google/GoogleCloudDirSync_linux_64bit_4_7_2.sh && \
  chmod +x /tmp/dirsync-install.sh && \
  touch /tmp/dirsync-install.varfile && \
  echo "sys.programGroup.linkDir=/usr/local/bin" >> /tmp/dirsync-install.varfile && \
  echo "sys.languageId=en" >> /tmp/dirsync-install.varfile && \
  echo "sys.installationDir=/opt/gcds" >> /tmp/dirsync-install.varfile && \
  echo "sys.programGroup.enabled$Boolean=true" >> /tmp/dirsync-install.varfile && \
  echo "sys.programGroup.allUsers$Boolean=true" >> /tmp/dirsync-install.varfile && \
  echo "sys.programGroup.name='Google Cloud Directory Sync'" >> /tmp/dirsync-install.varfile && \
  /tmp/dirsync-install.sh -q -varfile /tmp/dirsync-install.varfile && \
  rm -rf /tmp/dirsync-install.varfile && \
  rm -rf /tmp/dirsync-install.sh

# Configure environment for Google Cloud Directory Sync
RUN mkdir -p /opt/gcds/data && \
  cp -a /root/.java /opt/gcds/data/ && \
  rm -rf /root/.java && \
  ln -s /opt/gcds/data/.java /root/.java && \
  mkdir -p /opt/gcds/data/.syncState && \
  rm -rf /root/syncState && \
  ln -s /opt/gcds/data/.syncState /root/syncState

# Entrypoint
WORKDIR /
COPY docker-entrypoint.sh /
ENV GCDS_CONFIG=config.xml
ENV GCDS_SYNC_PERIOD=10m
ENV GCDS_SYNC_EXTRA_ARGUMENTS=
ENTRYPOINT [ "/docker-entrypoint.sh" ]
