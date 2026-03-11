# Dockerfile deployement YalepWeb
# Based on instructions: https://github.com/leanprover-community/lean4web/blob/main/doc/Installation.md (f2f3530)
FROM ubuntu:22.04
ARG NODE_VERSION=25

# Node installation, based on: https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-in-docker
# Use bash for the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Create a script file sourced by both interactive and non-interactive bash shells
ENV BASH_ENV=/root/.bash_env
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

RUN apt-get update \
    && apt-get install -y curl

# this appears now to be a dependancy for 'npm install'
RUN apt-get install -y libatomic1

# seems to be a bug : lean server crashes looking for /etc/localtime (may be related to https://github.com/leanprover-community/mathlib4/issues/31824 or https://github.com/leanprover-community/lean4game/issues/146)
RUN ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime                            \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends tzdata   \
    && dpkg-reconfigure --frontend noninteractive tzdata

# Download and install nvm to install node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | PROFILE="${BASH_ENV}" bash
RUN echo "$NODE_VERSION" > .nvmrc
RUN nvm install && npm --version

# Install yarn
RUN npm install --global yarn && yarn --version

# Git install
RUN apt-get install -y git

# Install lean
ENV PATH=/root/.elan/bin:$PATH
RUN curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y
RUN . ~/.profile \
    && elan toolchain install $(curl https://raw.githubusercontent.com/leanprover-community/mathlib/master/leanpkg.toml | grep lean_version | awk -F'"' '{print $2}') \
    && elan default stable

# Cloning YalepWeb repository  freezing at Yalep v0.1.2
RUN git clone git@gricad-gitlab.univ-grenoble-alpes.fr:yalep/yalepweb.git ;\
    cd yalepweb ;\
    git checkout v0.1.2 ;\
    rm -rf .git


# Bubblewrap install
# Optionnal: used for secure deploiement
#RUN apt-get install bubblewrap

# Lean4web install
RUN cd yalepweb \
    && npm install \
    && npm run build;

# Set listening port (default 8080)
ENV PORT=8080
EXPOSE 8080/tcp

# Cleaning
RUN apt-get -y autoclean

# Set launch environment
WORKDIR /yalepweb
CMD "/bin/bash" "-c" "npm run start:server"
