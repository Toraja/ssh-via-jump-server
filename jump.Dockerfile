FROM toraja/alps:latest

RUN apk update && \
	apk --no-cache add openssh augeas shadow

RUN augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/ssh/authorized_keys/%u"' && \
	augtool 'set /files/etc/ssh/sshd_config/PasswordAuthentication no' && \
	augtool 'set /files/etc/ssh/sshd_config/AllowTcpForwarding yes'

ARG user=jumper
ARG uid=2222
ARG gid=2222
RUN getent group ${user} >/dev/null 2>&1 || addgroup --gid ${gid} ${user}
RUN getent passwd ${user} >/dev/null 2>&1 || \
	useradd --create-home --password '*' --uid ${uid} --gid ${gid} --shell=/usr/bin/fish --comment 'SSH login user' ${user}

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN mkdir -p /var/run/sshd

ARG authorized_keys=id_rsa.pub
COPY sshnw1/${authorized_keys} /etc/ssh/authorized_keys/${user}

WORKDIR /home/${user}
COPY --chown=${user}:${user} sshnw2 .ssh
RUN chmod 700 .ssh

COPY daemon-ep.sh /tmp
ENTRYPOINT ["/tmp/daemon-ep.sh"]
