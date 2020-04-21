FROM rastasheep/ubuntu-sshd:18.04

RUN apt-get update
RUN apt-get install -yqq unzip && \
	apt-get install -yqq net-tools && \
	apt-get install -yqq kmod && \
	apt-get install -yqq iproute2

RUN mkdir /root/distance-server/
COPY server /root/distance-server/bin

RUN if [ ! -e "/root/distance-server/bin/DistanceServer.x86_64" ]; then \
	wget -O /root/distance-server/server.zip https://github.com/Corecii/Distance-Server/releases/download/0.2.0/DistanceServerLinux64.zip && \
	unzip /root/distance-server/server.zip -d /root/distance-server/bin && \
	mv /root/distance-server/bin/DistanceServer/* /root/distance-server/bin/ && \
	rm -r /root/distance-server/bin/DistanceServer \
	rm -r /root/distance-server/server.zip; \
	fi

COPY entry.sh /root/entry.sh

RUN chmod +x /root/distance-server/bin/DistanceServer.x86_64 && \
	chmod +x /root/entry.sh

CMD sh /root/entry.sh