#!/bin/sh

# RUN ["/usr/sbin/sshd"] does not keep running sshd somehow
# so run it inside script file
/usr/sbin/sshd

tail -f /dev/null
