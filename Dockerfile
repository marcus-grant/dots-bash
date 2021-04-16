# Dockerfile to setup a debian based bash testing environment
FROM debian
LABEL maintainer=marcusfg@gmail.com

RUN apt-get update && apt install -y \
    bash \
    less \
    git \
    curl \
    nano \
    tree

RUN export EDITOR=nano
RUN mkdir /root/.dots
RUN mkdir /root/.dots/bash
RUN rm /root/.bashrc
RUN ln -sf /root/.dots/bash/bashrc.bash /root/.bashrc
RUN ln -sf /root/.dots/bash/bashprofile.bash /root/.bash_profile
RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git /root/.dots/bash/bash-it

WORKDIR /root
