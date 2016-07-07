FROM ubuntu:latest

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -yqq mc htop ncdu sysstat tcpdump \
    openssh-server wget curl git
    # Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_6.x |bash -
RUN apt-get install -y nodejs && apt-get clean

RUN mkdir /var/run/sshd
RUN echo 'root:nuclide' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Install Nuclide Remote Server
RUN npm install -g nuclide

# Start ssh service
CMD ["/usr/sbin/sshd", "-D"]
