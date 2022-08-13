ARG PLATTFORM=fedora
ARG USERNAME=user
ARG PASSWORD=user
ARG PKG_INSTALL="dnf install -y"
ARG TARGET=init

FROM ${PLATTFORM}:latest as env
ARG PLATTFORM
ARG PASSWORD
ARG USERNAME
ARG PKG_INSTALL
ARG TARGET

ENV HOME /home/${USERNAME}

RUN eval ${PKG_INSTALL} \
        make \
        git \
        curl \
        xdg-utils \
        sudo 

RUN groupadd -f wheel
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
