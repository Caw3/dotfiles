ARG PLATTFORM=fedora
ARG USERNAME=user
ARG PKG_INSTALL="dnf install -y"
ARG TARGET=init

FROM ${PLATTFORM}:latest as env
ARG PLATTFORM
ARG USERNAME
ARG PKG_INSTALL
ARG TARGET

ENV HOME /home/${USERNAME}

RUN $PKG_INSTALL make
RUN $PKG_INSTALL git
RUN $PKG_INSTALL curl
RUN $PKG_INSTALL sudo
RUN $PKG_INSTALL xdg-utils

RUN useradd -m -r -G wheel -s /bin/bash ${USERNAME}
RUN echo "root:${PASSWORD}" | chpasswd
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
WORKDIR $HOME
USER ${USERNAME}

FROM env AS runner
ARG TARGET
COPY . $HOME/.dotfiles
WORKDIR $HOME/.dotfiles
RUN make ${TARGET}
