FROM nginx:1.9.4
MAINTAINER faithcreates <info@faithcreates.co.jp>

ADD nginx.conf /etc/nginx/nginx.conf
ADD ./dist /usr/share/nginx/html
