FROM nginx:alpine
COPY default.conf /etc/nginx/conf.d/default.conf
COPY ./mirror_doc /usr/share/nginx/html