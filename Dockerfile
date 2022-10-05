FROM ubuntu:latest

ARG SBVER=7.3.3beta

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -qq -y xvfb x11vnc fluxbox supervisor xterm libgbm-dev firefox novnc websockify net-tools openjdk-17-jre openjdk-17-jre-headless fonts-symbola unzip

RUN cd /tmp && \
        wget -q https://github.com/ProjectBots/StreamRaidersBot/releases/download/v${SBVER}/StreamRaidersBot.zip && \
        unzip StreamRaidersBot.zip && \
        mkdir -p /opt/srbot && \
        mv StreamRaidersBot_v${SBVER}/* /opt/srbot && \
        rm -r /tmp/StreamRaidersBot*

# INSTALL QUICK PATCH HERE
ADD src/${SBVER}-patch.zip /opt/srbot/data
RUN cd /opt/srbot/data && \
    unzip -o ${SBVER}-patch.zip && \
    rm ${SBVER}-patch.zip

RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

ADD src/supervisord.conf /etc/supervisord.conf
ADD src/menu /root/.fluxbox/menu
ADD src/entry.sh /entry.sh
ADD src/startBot.sh /startBot.sh

RUN chmod +x /entry.sh && chmod +x /startBot.sh

ENV DISPLAY :0
ENV RESOLUTION=1024x768

EXPOSE 5901 6901

ENTRYPOINT ["/bin/bash", "-c", "/entry.sh"]