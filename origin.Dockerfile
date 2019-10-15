FROM toraja/alps:latest

RUN apk update && \
	apk --no-cache add openssh augeas shadow

ARG user=ssher
ARG uid=2222
ARG gid=2222
RUN getent group ${user} >/dev/null 2>&1 || addgroup --gid ${gid} ${user} && \
RUN getent passwd ${user} >/dev/null 2>&1 || \
	useradd --create-home --password '*' --uid ${uid} --gid ${gid} --shell=/usr/bin/fish --comment 'SSH user' ${user}

WORKDIR /home/${user}
COPY --chown=${user}:${user} sshnw1 .ssh
COPY --chown=${user}:${user} sshnw2/id_rsa .ssh/id_rsa_dest
RUN chmod 700 .ssh

ENTRYPOINT ["tail", "-f", "/dev/null"]
