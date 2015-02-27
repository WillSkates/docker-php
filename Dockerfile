FROM        ubuntu:14.04
MAINTAINER  Will Skates "wlskates12@gmail.com"

RUN apt-get update
RUN apt-get -y upgrade

#Lets force the system into using a UTF8 language
RUN export LANG=C.UTF-8

#Install what we need to get the latest versions of the software we need.
RUN apt-get install -y python-software-properties software-properties-common pkg-config python-setuptools python-pip

#Install some generic software that we may need.
RUN apt-get install -y curl wget nano

#Add repositories that contain the latest version of php.
RUN add-apt-repository -y ppa:ondrej/php5-5.6

#Install php and the fast process manager, pear and the php development files that allow us to install third party extensions.
RUN apt-get install -y php5-cli php5-fpm php-pear php5-dev

#Install some php addons.
RUN apt-get install -y php5-imagick php5-mysql php5-imap php5-mcrypt php5-curl php5-gd php5-json

#Install ZeroMQ -optional really
RUN wget http://download.zeromq.org/zeromq-4.0.5.tar.gz -P /tmp
RUN tar -zxvf /tmp/zeromq-4.0.5.tar.gz -C /tmp
RUN cd /tmp/zeromq-4.0.5
RUN ./tmp/zeromq-4.0.5/configure
RUN make
RUN make install
RUN pecl install zmq-1.1.2
RUN touch /etc/php5/mods-available/zmq.ini
RUN echo "extension=zmq.so" >> /etc/php5/mods-available/zmq.ini
RUN php5enmod zmq

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini

ADD www.conf /etc/php5/fpm/pool.d/www.conf

#Configure permissions
RUN mkdir -p /home/app && chown -R www-data:www-data /home/app

