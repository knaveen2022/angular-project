FROM nginx:1.17.1-alpine

RUN chmod g+rwx /var/cache/nginx  /var/run /var/log/nginx 

RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf

EXPOSE 8081

RUN addgroup nginx root 

COPY dist/. /usr/share/nginx/html 

COPY conf /etc/nginx

RUN chmod -R 777 /usr/share/nginx/html

USER nginx
