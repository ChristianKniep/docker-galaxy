###### QNIBng image
FROM qnib/nginx
MAINTAINER "Christian Kniep <christian@qnib.org>"

RUN cd /opt/ && \
    wget -q https://github.com/galaxyproject/galaxy/archive/master.tar.gz && \
    tar xf master.tar.gz && mv galaxy-master galaxy && rm -f master.tar.gz
RUN yum install -y gcc zlib-devel python-devel sqlite-devel
RUN python /opt/galaxy/./scripts/fetch_eggs.py -c /opt/galaxy/config/galaxy.ini.sample
ADD opt/galaxy/config/galaxy.ini /opt/galaxy/config/galaxy.ini
ADD etc/nginx/nginx.conf /etc/nginx/
ADD etc/nginx/conf.d/galaxy.conf /etc/nginx/conf.d/
ADD etc/supervisord.d/galaxy.ini /etc/supervisord.d/galaxy.ini
ADD etc/consul.d/check_galaxy.json /etc/consul.d/
