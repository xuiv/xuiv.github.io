FROM gitpod/workspace-full:latest

USER root

# Install Xvfb, JavaFX-helpers and Openbox window manager
RUN apt-get update \
    && apt-get install -yq xvfb x11vnc xterm megatools fonts-droid-fallback fluxbox \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

# overwrite this env variable to use a different window manager
ENV WINDOW_MANAGER="fluxbox"

# Install novnc
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

RUN curl -O -L https://github.com/xuiv/gost-heroku/releases/download/1.01/gost-linux \
 && curl -O -L https://github.com/xuiv/v2ray-heroku/releases/download/1.01/v2ray-linux \
 && curl -O -L https://github.com/xuiv/v2ray-heroku/releases/download/1.01/server.json \
 && mv gost-linux /usr/bin/ \
 && mv v2ray-linux /usr/bin/ \
 && mv server.json /usr/bin/ \
 && chmod +x /usr/bin/gost-linux \
 && chmod +x /usr/bin/v2ray-linux \
 && chmod 644 /usr/bin/server.json

RUN curl -O -L https://raw.githubusercontent.com/gitpod-io/workspace-images/master/full-vnc/novnc-index.html \
 && curl -O -L https://raw.githubusercontent.com/gitpod-io/workspace-images/master/full-vnc/start-vnc-session.sh \
 && mv novnc-index.html /opt/novnc/index.html \
 && mv start-vnc-session.sh /usr/bin/ \
 && chmod +x /usr/bin/start-vnc-session.sh \
 && sed -ri "s/1920x1080/1366x830/g" /usr/bin/start-vnc-session.sh \
 && sed -ri '/\$WINDOW_MANAGER &/a\xterm &' /usr/bin/start-vnc-session.sh

# This is a bit of a hack. At the moment we have no means of starting background
# tasks from a Dockerfile. This workaround checks, on each bashrc eval, if the X
# server is running on screen 0, and if not starts Xvfb, x11vnc and novnc.
RUN echo "export PORT=1080" >> ~/.bashrc \
 && echo "export DISPLAY=:0" >> ~/.bashrc \
 && echo "" >> ~/.bashrc \
 && echo "vvv=\`pstree |grep gost\`" >> ~/.bashrc \
 && echo "if [ \"\${vvv}\"x = \"\"x ]" >> ~/.bashrc \
 && echo "then" >> ~/.bashrc \
 && echo "  nohup gost-linux -L quic+ws://:1081 >/dev/null 2>&1 &" >> ~/.bashrc \
 && echo "  nohup v2ray-linux -config /usr/bin/server.json >/dev/null 2>&1 &" >> ~/.bashrc \
 && echo "  [ ! -e /tmp/.X0-lock ] && (nohup /usr/bin/start-vnc-session.sh &> /tmp/display-\${DISPLAY}.log >/dev/null 2>&1 &)" >> ~/.bashrc \
 && echo "fi" >> ~/.bashrc

### checks ###
# no root-owned files in the home directory
RUN notOwnedFile=$(find . -not "(" -user gitpod -and -group gitpod ")" -print -quit) \
    && { [ -z "$notOwnedFile" ] \
        || { echo "Error: not all files/dirs in $HOME are owned by 'gitpod' user & group"; exit 1; } }
