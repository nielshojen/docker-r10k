FROM ubuntu:18.04

ARG vcs_ref
ARG build_date
ARG version="3.1.0"
ENV R10K_VERSION="$version"
ENV UBUNTU_CODENAME="bionic"

LABEL org.label-schema.maintainer="Niels Højen <niels@hojen.net>" \
      org.label-schema.vendor="Puppet" \
      org.label-schema.url="https://github.com/puppetlabs/r10k" \
      org.label-schema.name="r10k" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.version="$R10K_VERSION" \
      org.label-schema.vcs-url="https://github.com/puppetlabs/r10k" \
      org.label-schema.vcs-ref="$vcs_ref" \
      org.label-schema.build-date="$build_date" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.dockerfile="/Dockerfile"

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget ca-certificates lsb-release && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
    wget https://apt.puppetlabs.com/puppet6-release-"$UBUNTU_CODENAME".deb && \
    dpkg -i puppet6-release-"$UBUNTU_CODENAME".deb && \
    rm puppet6-release-"$UBUNTU_CODENAME".deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y puppet-agent && \
    apt-get install --no-install-recommends -y git git-lfs openssh-client && \
    apt-get remove --purge -y wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /etc/apt/sources.list.d/github_git-lfs.list && \
    mkdir /root/.ssh && \
    chmod 0600 /root/.ssh && \
    echo StrictHostKeyChecking no > /root/.ssh/config

RUN /opt/puppetlabs/puppet/bin/gem install r10k:"$R10K_VERSION"

ENV PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH

ENTRYPOINT ["/opt/puppetlabs/puppet/bin/r10k"]
CMD ["help"]

COPY Dockerfile /
