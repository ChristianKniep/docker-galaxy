###### QNIBng image
FROM qnib/slurmd
MAINTAINER "Christian Kniep <christian@qnib.org>"

### install nginx
RUN yum clean all;yum install -y nginx
RUN sed -i '/worker_processes.*/a daemon off;' /etc/nginx/nginx.conf
ADD etc/supervisord.d/nginx.ini /etc/supervisord.d/nginx.ini
ADD opt/qnib/bin/start_nginx.sh /opt/qnib/bin/start_nginx.sh
# php
RUN yum install -y php-fpm
ADD etc/supervisord.d/php-fpm.ini /etc/supervisord.d/
ADD etc/consul.d/check_nginx.json /etc/consul.d/
#### Galaxy
RUN cd /opt/ && \
    wget -q https://github.com/galaxyproject/galaxy/archive/master.tar.gz && \
    tar xf master.tar.gz && mv galaxy-master galaxy && rm -f master.tar.gz
RUN yum install -y gcc zlib-devel python-devel sqlite-devel
RUN python /opt/galaxy/./scripts/fetch_eggs.py -c /opt/galaxy/config/galaxy.ini.sample
ADD etc/nginx/nginx.conf /etc/nginx/
ADD etc/nginx/conf.d/galaxy.conf /etc/nginx/conf.d/
ADD etc/supervisord.d/galaxy.ini /etc/supervisord.d/galaxy.ini
ADD etc/consul.d/check_galaxy.json /etc/consul.d/
RUN yum install -y automake libtool
RUN cd /opt/ && \
    curl -Ls -o slurm-drmaa-1.0.7.tar.gz  http://apps.man.poznan.pl/trac/slurm-drmaa/downloads/9 && \
    tar xf slurm-drmaa-1.0.7.tar.gz && rm -f slurm-drmaa-1.0.7.tar.gz 
RUN cd /opt/slurm-drmaa-1.0.7/ && \
    sh autogen.sh && \
    ./configure --with-slurm-inc=/usr/local/include/ \
                --with-slurm-lib=/usr/local/lib/ && \
    make && make install
ADD opt/galaxy/config/galaxy.ini /opt/galaxy/config/galaxy.ini
