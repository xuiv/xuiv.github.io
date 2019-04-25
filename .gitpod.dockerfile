FROM gitpod/workspace-full:latest

USER root

# Install Xvfb, JavaFX-helpers and Openbox window manager
RUN apt-get update \
    && apt-get install -yq xvfb x11vnc xterm openjfx libopenjfx-java mousepad firefox deluge deluge-gtk megatools fonts-droid-fallback fluxbox \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

# overwrite this env variable to use a different window manager
ENV WINDOW_MANAGER="fluxbox"

# Install novnc
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

RUN __GOST_VERSION__="2.7.2" \
 && curl -L https://github.com/ginuerzh/gost/releases/download/v${__GOST_VERSION__}/gost_${__GOST_VERSION__}_linux_amd64.tar.gz | tar xz \
 && mv gost_${__GOST_VERSION__}_linux_amd64/gost /usr/bin/ \
 && chmod +x /usr/bin/gost \
 && rm -rf gost_${__GOST_VERSION__}_linux_amd64

RUN curl -O -L https://raw.githubusercontent.com/gitpod-io/workspace-images/master/full-vnc/novnc-index.html \
 && curl -O -L https://raw.githubusercontent.com/gitpod-io/workspace-images/master/full-vnc/start-vnc-session.sh \
 && mv novnc-index.html /opt/novnc/index.html \
 && mv start-vnc-session.sh /usr/bin/ \
 && chmod +x /usr/bin/start-vnc-session.sh \
 && sed -ri "s/1920x1080/1366x830/g" /usr/bin/start-vnc-session.sh \
 && echo "gost -L socks+ws://:1080 >/dev/null 2>&1 &" >>/usr/bin/start-vnc-session.sh

# This is a bit of a hack. At the moment we have no means of starting background
# tasks from a Dockerfile. This workaround checks, on each bashrc eval, if the X
# server is running on screen 0, and if not starts Xvfb, x11vnc and novnc.
RUN echo "export DISPLAY=:0" >> ~/.bashrc
RUN echo "[ ! -e /tmp/.X0-lock ] && (/usr/bin/start-vnc-session.sh &> /tmp/display-\${DISPLAY}.log)" >> ~/.bashrc

### checks ###
# no root-owned files in the home directory
RUN notOwnedFile=$(find . -not "(" -user gitpod -and -group gitpod ")" -print -quit) \
    && { [ -z "$notOwnedFile" ] \
        || { echo "Error: not all files/dirs in $HOME are owned by 'gitpod' user & group"; exit 1; } }
