FROM openresty/openresty:1.21.4.1-0-jammy

# Install dependencies
RUN apt-get update
RUN apt-get install -y \
    wget \
    gnupg2 \
    dpkg \
    supervisor

# Static Nginx Configuration
COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
RUN mkdir -p /var/log/nginx/
RUN touch /var/log/nginx/access.log

# Copy Supervisor configuration
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Install OpenID Connect Library & Dependencies
RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-http
RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-session
RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-jwt
RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-openidc

# Copy Scripts
COPY ./lua /usr/local/openresty/nginx/conf/lua

# Install GoAccess
RUN wget -O - https://deb.goaccess.io/gnugpg.key | gpg --dearmor | tee /usr/share/keyrings/goaccess.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/goaccess.gpg arch=$(dpkg --print-architecture)] https://deb.goaccess.io/ jammy main" | tee /etc/apt/sources.list.d/goaccess.list
RUN apt-get update
RUN apt-get install -y goaccess


ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]