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

# FOR building py build to test asdf for python
RUN apt-get update; sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
dirmngr gpg gawk

RUN useradd -ms /bin/bash test; echo "test:test" | chpasswd; adduser test sudo

RUN mkdir /root/.dots
RUN mkdir -p /root/.local/share
RUN ln -sf /home/test/.dots/bash/rc.bash /home/test/.bashrc
RUN ln -sf /home/test/.dots/bash/profile.bash /home/test/.bash_profile
RUN ln -sf /root/.dots/bash/rc.bash /root/.bashrc
RUN ln -sf /root/.dots/bash/profile.bash /root/.bash_profile
RUN echo '. ~/.bash_profile; . ~/.bashrc; mesg n 2> /dev/null || true' > /root/.profile
RUN git clone git://github.com/pyenv/pyenv.git /pyenv
RUN /pyenv/plugins/python-build/install.sh

USER test
RUN mkdir -p /home/test/.dots
RUN mkdir -p /home/test/.local/share
RUN echo '. ~/.bash_profile; . ~/.bashrc; mesg n 2> /dev/null || true' > /home/test/.profile
RUN git clone https://github.com/asdf-vm/asdf.git ~/.local/share/asdf --branch v0.8.1
# RUN asdf plugin-add python
WORKDIR /home/test
