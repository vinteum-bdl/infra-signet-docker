FROM debian:stable-slim

ARG BITCOIN_VERSION="29.0"
ENV PATH=/opt/bitcoin-${BITCOIN_VERSION}/bin:$PATH

RUN apt-get update -y \
  && apt-get install -y curl ca-certificates gosu jq \
                        net-tools nano nmap git \
                        netcat-traditional vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG USERID=1000
ARG GROUPID=1000
RUN groupadd -g $GROUPID student && \
  useradd -u $USERID -g student -m -s /bin/bash student

RUN SYS_ARCH="$(uname -m)" \
  && curl -SLO https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-${SYS_ARCH}-linux-gnu.tar.gz \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz

COPY bitcoin.conf /etc/bitcoin.conf
RUN chown -R student:student /home/student

EXPOSE 38332 38333 38334

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /home/student
CMD [ "bash" ]
