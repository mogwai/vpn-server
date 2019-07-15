FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y openssh-server python sudo
RUN mkdir /var/run/sshd

RUN mkdir -p /root/.ssh
COPY ansible /root/.ssh/id_rsa
COPY ansible.pub /root/.ssh/id_rsa.pub
RUN  cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"] 