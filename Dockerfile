
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y openssh-server sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd

RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd

RUN usermod -aG sudo ansible && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible && \
    chmod 0440 /etc/sudoers.d/ansible

RUN sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
