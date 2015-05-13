FROM centos:centos6
MAINTAINER Benjamin Schwarze <benjamin.schwarze@mailboxd.de>

RUN yum update -y

RUN yum install -y openssh-server sudo tar wget

# generate SSH keys on first run
RUN /etc/init.d/sshd start

RUN groupadd vagrant && \
    useradd vagrant -g vagrant -G wheel && \
    echo "vagrant:vagrant" | chpasswd && \
    echo "Defaults !requiretty" >> /etc/sudoers.d/vagrant && \
    echo "vagrant   ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers.d/vagrant && \
    chmod 0440 /etc/sudoers.d/vagrant

RUN mkdir -pm 700 /home/vagrant/.ssh && \
    wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys && \
    chmod 0600 /home/vagrant/.ssh/authorized_keys && \
    chown -R vagrant /home/vagrant/.ssh

# expose SSH port
EXPOSE 22

# run SSH daemon
CMD ["/usr/sbin/sshd", "-D"]
