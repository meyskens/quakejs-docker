FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install sudo curl git nodejs npm jq apache2 wget apt-utils -y

RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

RUN git clone --recurse-submodules https://github.com/begleysm/quakejs.git
WORKDIR /quakejs
RUN npm install

COPY server.cfg /quakejs/base/baseq3/server.cfg
COPY server.cfg /quakejs/base/cpma/server.cfg
COPY ./include/ioq3ded/ioq3ded.fixed.js /quakejs/build/ioq3ded.js

RUN rm /var/www/html/index.html && cp /quakejs/html/* /var/www/html/
COPY ./include/assets/ /var/www/html/assets

RUN echo "127.0.0.1 content.quakejs.com" >> /etc/hosts

WORKDIR /
ADD entrypoint.sh /entrypoint.sh
# Was having issues with Linux and Windows compatibility with chmod -x, but this seems to work in both
RUN chmod 777 ./entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
