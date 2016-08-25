FROM                    ubuntu:16.04
MAINTAINER              pr3d4t0r


LABEL                   author="pr3d4t0r - Eugene Ciurana"
LABEL                   copyright="(c) Copyright 2016 by sabre.io"
LABEL                   description="Sculpin in a container for static web generation"
LABEL                   support="irc://irc.freenode.net/#sabredav"
LABEL                   version="1.0"


### "set-locale"
RUN                     locale-gen en_US.UTF-8 && \
                        update-locale LANG=en_US.UTF-8 && \
                        update-locale LANGUAGE=en_US.UTF-8 && \
                        update-locale LC_ALL=en_US.UTF-8

ENV                     LANG en_US.UTF-8
ENV                     LANGUAGE en_US:en
ENV                     LC_ALL en_US.UTF-8
ENV                     TERM=xterm


### "configure-apt"
RUN                     echo "APT::Get::Assume-Yes true;" >> /etc/apt/apt.conf.d/80custom; \
                        echo "APT::Get::Quiet true;" >> /etc/apt/apt.conf.d/80custom; \
                        rm -Rvf /var/lib/apt/lists/*; \
                        apt-get update


### "system-requirements"
RUN                     apt-get install git
RUN                     apt-get install php
RUN                     apt-get install php-curl
RUN                     apt-get install php-date
RUN                     apt-get install php-dom
RUN                     apt-get install php-mbstring
RUN                     apt-get install php-zip


### "installation"
WORKDIR                 /var/www
RUN                     php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN                     php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN                     php composer-setup.php
RUN                     php -r "unlink('composer-setup.php');"
RUN                     mv composer.phar /usr/local/bin/composer


### "web-server-configuration-and-launch"
WORKDIR                 /
COPY                    bin/runsculpin /

# httpoxy vulnerability fix:
# RUN                     awk '/vim: syntax/ { printf("# Poxy; CVE-2016-5387\nLoadModule headers_module /usr/lib/apache2/modules/mod_headers.so\nRequestHeader unset Proxy early\n%s\n", $0); next; } { print; }' /etc/apache2/apache2.conf > /tmp/apache2.conf
# RUN                     cat /tmp/apache2.conf > /etc/apache2/apache2.conf && rm /tmp/apache2.conf

ENTRYPOINT                [ "/runsculpin" ]

