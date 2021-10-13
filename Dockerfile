# Dockerfile to setup a debian based bash testing environment
FROM debian
LABEL maintainer=marcusfg@gmail.com

RUN apt-get update && apt install -y \
    bash \
    sudo \
    firewalld \
    less \
    sed \
    git \
    curl \
    nano \
    fzf \
    fd-find \
    vim 

RUN useradd -ms /bin/bash test; echo "test:test" | chpasswd; adduser test sudo

RUN mkdir /home/test/.dots
RUN mkdir /root/.dots
RUN ln -sf /home/test/.dots/bash/rc.bash /home/test/.bashrc
RUN ln -sf /home/test/.dots/bash/profile.bash /home/test/.bash_profile
RUN ln -sf /root/.dots/bash/rc.bash /root/.bashrc
RUN ln -sf /root/.dots/bash/profile.bash /root/.bash_profile
RUN echo '. ~/.bash_profile; . ~/.bashrc; mesg n 2> /dev/null || true' > /root/.profile

USER test
RUN echo '. ~/.bash_profile; . ~/.bashrc; mesg n 2> /dev/null || true' > /home/test/.profile
WORKDIR /home/test
