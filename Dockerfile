FROM nginx

RUN apt-get update && \
    apt-get -y install certbot && \
    apt-get -y install python3-certbot-nginx

