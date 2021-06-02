FROM gitpod/workspace-full:latest

USER root

# Install Xvfb, JavaFX-helpers and Openbox window manager
RUN add-apt-repository ppa:no1wantdthisname/ppa && apt-get update && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq language-pack-zh-hans-base xvfb x11vnc xterm megatools fonts-droid-fallback fonts-wqy-microhei fluxbox blackbox firefox lxterminal pcmanfm mousepad vim-nox emacs-nox aria2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone

# overwrite this env variable to use a different window manager
ENV LANG="zh_CN.UTF-8" 
ENV WINDOW_MANAGER="fluxbox"

# Install novnc
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

RUN curl -O -L https://github.com/xuiv/gost-heroku/releases/download/1.01/gost-linux \
 && curl -O -L https://github.com/xuiv/v2ray-heroku/releases/download/1.01/v2ray-linux \
 && curl -O -L https://github.com/xuiv/v2ray-heroku/releases/download/1.01/server.json \
 && curl -o - -L https://github.com/hyxf/webui/releases/download/1.0.0/webui-linux.gz | gunzip > webui-linux \
 && mv gost-linux /usr/bin/ \
 && mv v2ray-linux /usr/bin/ \
 && mv server.json /usr/bin/ \
 && mv webui-linux /usr/bin/ \
 && chmod +x /usr/bin/gost-linux \
 && chmod +x /usr/bin/v2ray-linux \
 && chmod 644 /usr/bin/server.json \
 && chmod +x /usr/bin/webui-linux

RUN curl -O -L https://raw.githubusercontent.com/gitpod-io/workspace-images/master/full-vnc/novnc-index.html \
 && curl -O -L https://raw.githubusercontent.com/gitpod-io/workspace-images/master/full-vnc/start-vnc-session.sh \
 && mv novnc-index.html /opt/novnc/index.html \
 && mv start-vnc-session.sh /usr/bin/ \
 && chmod +x /usr/bin/start-vnc-session.sh \
 && sed -ri "s/1920x1080/1366x830/g" /usr/bin/start-vnc-session.sh \
 && sed -ri "s/Bitstream Vera Sans-9/WenQuanYi Micro Hei Mono-10/g" /usr/share/blackbox/styles/Gray \
 && sed -ri "s/Bitstream Vera Sans-9/WenQuanYi Micro Hei Mono-10/g" /usr/share/blackbox/styles/Green \
 && sed -ri "s/Bitstream Vera Sans-9/WenQuanYi Micro Hei Mono-10/g" /usr/share/blackbox/styles/Blue \
 && sed -ri "s/Bitstream Vera Sans-9/WenQuanYi Micro Hei Mono-10/g" /usr/share/blackbox/styles/Purple \
 && sed -ri "s/Bitstream Vera Sans-9/WenQuanYi Micro Hei Mono-10/g" /usr/share/blackbox/styles/Red \
 && sed -ri '/Automatically generated/a\   \[exec\] \(Xterm\) \{ x-terminal-emulator -T "Bash" -e /bin/bash --login\} \<\>' /etc/X11/fluxbox/fluxbox-menu \
 && sed -ri '/Automatically generated/a\   \[exec\] \(LXterm\) \{lxterminal\} \<\>' /etc/X11/fluxbox/fluxbox-menu \
 && sed -ri '/Automatically generated/a\   \[exec\] \(Filemanager\) \{pcmanfm\} \<\>' /etc/X11/fluxbox/fluxbox-menu \
 && sed -ri '/Automatically generated/a\   \[exec\] \(Deluge\) \{deluge-gtk\} \<\>' /etc/X11/fluxbox/fluxbox-menu \
 && sed -ri '/Automatically generated/a\   \[exec\] \(Mousepad\) \{mousepad\} \<\>' /etc/X11/fluxbox/fluxbox-menu \
 && sed -ri '/Automatically generated/a\   \[exec\] \(Firefox\) \{firefox\} \<\>' /etc/X11/fluxbox/fluxbox-menu \
 && mv /etc/X11/blackbox/blackbox-menu /etc/X11/blackbox/blackbox-menu.orig \
 && echo "[begin] (Menu)" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [exec] (Firefox) {firefox}" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [exec] (Mousepad) {mousepad}" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [exec] (Deluge) {deluge-gtk}" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [exec] (Filemanager) {pcmanfm}" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [exec] (LXterm) {lxterminal}" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [sep]" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [config] (Configuration)" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [submenu] (Styles)" >> /etc/X11/blackbox/blackbox-menu \
 && echo "      [stylesdir] (/usr/share/blackbox/styles)" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [end]" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [workspaces] (Workspaces)" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [sep]" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [submenu] (Window Managers)" >> /etc/X11/blackbox/blackbox-menu \ 
 && echo "      [restart] (Blackbox)  {/usr/bin/blackbox}" >> /etc/X11/blackbox/blackbox-menu \ 
 && echo "      [restart] (FluxBox)  {/usr/bin/startfluxbox}" >> /etc/X11/blackbox/blackbox-menu \ 
 && echo "   [end]" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [reconfig] (Reconfigure)" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [restart] (Restart)" >> /etc/X11/blackbox/blackbox-menu \
 && echo "   [exit] (Exit)" >> /etc/X11/blackbox/blackbox-menu \
 && echo "[end]" >> /etc/X11/blackbox/blackbox-menu
 

# This is a bit of a hack. At the moment we have no means of starting background
# tasks from a Dockerfile. This workaround checks, on each bashrc eval, if the X
# server is running on screen 0, and if not starts Xvfb, x11vnc and novnc.
RUN echo "export PORT=1080" >> ~/.bashrc \
 && echo "export DISPLAY=:0" >> ~/.bashrc \
 && echo "" >> ~/.bashrc \
 && echo "vvv=\`pstree |grep gost\`" >> ~/.bashrc \
 && echo "if [ \"\${vvv}\"x = \"\"x ]" >> ~/.bashrc \
 && echo "then" >> ~/.bashrc \
 && echo "  sudo mount -t tmpfs -o size=20g tmpfs /mnt" >> ~/.bashrc \
 && echo "  nohup gost-linux -L quic+ws://:1081 >/dev/null 2>&1 &" >> ~/.bashrc \
 && echo "  pushd /tmp && curl -O -L https://raw.githubusercontent.com/xuiv/xuiv.github.io/master/aria2.conf && bash <(curl -fsSL git.io/tracker.sh) && popd" >> ~/.bashrc \
 && echo "  nohup aria2c --dir /mnt --enable-rpc --rpc-listen-all --listen-port=8088 --enable-dht=true --dht-listen-port=8088 -c --conf-path=/tmp/aria2.conf -D >/dev/null 2>&1 &" >> ~/.bashrc \
 && echo "  nohup webui-linux --port 8080 >/dev/null 2>&1 &" >> ~/.bashrc \
 && echo "  nohup v2ray-linux -config /usr/bin/server.json >/dev/null 2>&1 &" >> ~/.bashrc \
 && echo "  [ ! -e /tmp/.X0-lock ] && (nohup /usr/bin/start-vnc-session.sh &> /tmp/display-\${DISPLAY}.log >/dev/null 2>&1 &)" >> ~/.bashrc \
 && echo "fi" >> ~/.bashrc

### checks ###
# no root-owned files in the home directory
RUN notOwnedFile=$(find . -not "(" -user gitpod -and -group gitpod ")" -print -quit) \
    && { [ -z "$notOwnedFile" ] \
        || { echo "Error: not all files/dirs in $HOME are owned by 'gitpod' user & group"; exit 1; } }
