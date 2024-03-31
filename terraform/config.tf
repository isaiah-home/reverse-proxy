resource "local_file" "nginx_conf" {
  filename = "${var.install_root}/nginx/nginx.conf"
  content = <<-EOT
    #test
    #user  nginx;
    #worker_processes  auto;
    
    #error_log  /var/log/nginx/error.log notice;
    #pid        /var/run/nginx.pid;
    
    
    events {
        worker_connections  1024;
    }
    
    
    http {
        include       mime.types;
        default_type  application/octet-stream;
    
        #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
        #                  '$status $body_bytes_sent "$http_referer" '
        #                  '"$http_user_agent" "$http_x_forwarded_for"';
    
        #access_log  /var/log/nginx/access.log  main;
    
        # See Move default writable paths to a dedicated directory (#119)
        # https://github.com/openresty/docker-openresty/issues/119
        client_body_temp_path /var/run/openresty/nginx-client-body;
        proxy_temp_path       /var/run/openresty/nginx-proxy;
        fastcgi_temp_path     /var/run/openresty/nginx-fastcgi;
        uwsgi_temp_path       /var/run/openresty/nginx-uwsgi;
        scgi_temp_path        /var/run/openresty/nginx-scgi;
    
        sendfile        on;
        #tcp_nopush     on;
    
        keepalive_timeout  65;
    
        #gzip  on;

        include /etc/nginx/conf.d/*.conf;
    
        # When adding a subdomain, add the following server block before running certbot
        # When running certbot, user the --expand flag to add to the domain list
        # The reverse proxy can be setup after the subdomain is registered
        #
        #server {
        #    listen 80;
        #    server_name $subdomain.vanderelst.house;
        #}
    
        #resolver local=on;
        resolver 127.0.0.11;
    
        server {
            server_name snipeit.${var.domain};
    
            listen 443 ssl;
            ssl_certificate     /etc/letsencrypt/live/${var.domain}/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/${var.domain}/privkey.pem;
            ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
            ssl_ciphers         HIGH:!aNULL:!MD5;
    
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
            #add_header X-Content-Type-Options nosniff;    # cannot apply now because of open keycloak issue https://issues.redhat.com/browse/KEYCLOAK-17076
            add_header X-XSS-Protection: "1; mode=block";
    
            location / {
                proxy_set_header        Host $host;
                proxy_set_header        X-Real-IP $remote_addr;
                proxy_set_header        X-Forwarded-Proto $scheme;
    
                set $proxy_uri          http://snipeit:80;
                proxy_pass              $proxy_uri;
            }
        }
    
        server {
            server_name nextcloud.${var.domain};
    
            client_max_body_size 500M;
    
            listen 443 ssl;
            ssl_certificate     /etc/letsencrypt/live/${var.domain}/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/${var.domain}/privkey.pem;
            ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
            ssl_ciphers         HIGH:!aNULL:!MD5;
    
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
            #add_header X-Content-Type-Options nosniff;    # cannot apply now because of open keycloak issue https://issues.redhat.com/browse/KEYCLOAK-17076
            add_header X-XSS-Protection: "1; mode=block";
    
    
            location / {
                proxy_set_header        Host $host;
                proxy_set_header        X-Real-IP $remote_addr;
                proxy_set_header        Referer $http_referer;
                proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header        X-Forwarded-Proto $scheme;
    
                set $proxy_uri          http://nextcloud:80;
                proxy_pass              $proxy_uri;
            }
    
        }
    
        server {
            server_name auth.${var.domain};
        
            listen 443 ssl;
            ssl_certificate     /etc/letsencrypt/live/${var.domain}/fullchain.pem; # managed by Certbot
            ssl_certificate_key /etc/letsencrypt/live/${var.domain}/privkey.pem; # managed by Certbot
            ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
            ssl_ciphers         HIGH:!aNULL:!MD5;
    
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
            add_header Content-Security-Policy "default-src 'self'; frame-ancestors 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src http://auth.${var.domain};";
            #add_header X-Content-Type-Options nosniff;    # cannot apply now because of open keycloak issue https://issues.redhat.com/browse/KEYCLOAK-17076
            add_header X-XSS-Protection: "1; mode=block";
    
            proxy_busy_buffers_size   512k;
            proxy_buffers             4 512k;
            proxy_buffer_size         256k;
    
            location /auth/admin {
                return 404;
            }
    
            location / {
                proxy_set_header        Host $host;
                proxy_set_header        X-Real-IP $remote_addr;
                proxy_set_header        Referer $http_referer;
                proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header        X-Forwarded-Proto $scheme;
    
                set $proxy_uri          http://keycloak:8080;
                proxy_pass              $proxy_uri;
            }
            
        }
    
        server {
            server_name wiki.${var.domain};
     
            client_max_body_size 500M;
        
            listen 443 ssl; # managed by Certbot
            ssl_certificate     /etc/letsencrypt/live/${var.domain}/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/${var.domain}/privkey.pem;
            ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
            ssl_ciphers         HIGH:!aNULL:!MD5;
    
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
            #add_header X-Content-Type-Options nosniff;    # cannot apply now because of open keycloak issue https://issues.redhat.com/browse/KEYCLOAK-17076
            add_header X-XSS-Protection: "1; mode=block";
    
            location / {
                proxy_set_header        Host $host;
                proxy_set_header        X-Real-IP $remote_addr;
                proxy_set_header        Referer $http_referer;
                proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header        X-Forwarded-Proto $scheme;
    
                set $proxy_uri          http://wikijs:3000;
                proxy_pass              $proxy_uri;
            }        
        }
     
        server {
            server_name vaultwarden.${var.domain};
    
            client_max_body_size 500M;
    
            listen 443 ssl;
            ssl_certificate     /etc/letsencrypt/live/${var.domain}/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/${var.domain}/privkey.pem;
            ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
            ssl_ciphers         HIGH:!aNULL:!MD5;
     
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
            #add_header X-Content-Type-Options nosniff;    # cannot apply now because of open keycloak issue https://issues.redhat.com/browse/KEYCLOAK-17076
            add_header X-XSS-Protection: "1; mode=block";
    
            location /admin {
                return 404;
            }
    
            location / {
                proxy_set_header        Host $host;
                proxy_set_header        X-Real-IP $remote_addr;
                proxy_set_header        Referer $http_referer;
                proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header        X-Forwarded-Proto $scheme;
    
                set $proxy_uri          http://vaultwarden:80;
                proxy_pass              $proxy_uri;
            }
        }
        
        server {
            server_name pihole.${var.domain};
    
            listen 443 ssl;
    
            keepalive_timeout   70;
            ssl_certificate     /etc/letsencrypt/live/${var.domain}/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/${var.domain}/privkey.pem;
            ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
            ssl_ciphers         HIGH:!aNULL:!MD5;
    
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
            #add_header X-Content-Type-Options nosniff;    # cannot apply now because of open keycloak issue https://issues.redhat.com/browse/KEYCLOAK-17076
            add_header X-XSS-Protection: "1; mode=block";
    
    
            location / {
                default_type 'text/html';
                
                set $ssl_verify       no;
                set $redirect_uri     https://pihole.${var.domain}/login;
                set $discovery        https://auth.${var.domain}/auth/realms/home/.well-known/openid-configuration;
                set $client_id        ${var.pihole_client_id};
                set $client_secret    ${var.pihole_secret_id};
    
                access_by_lua_file /usr/local/openresty/nginx/conf/lua/authenticate.lua;
            
                proxy_set_header        Host $host;
                proxy_set_header        X-Real-IP $remote_addr;
                proxy_set_header        Referer $http_referer;
                proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header        X-Forwarded-Proto $scheme;
    
                set $proxy_uri          http://pihole:80;
                proxy_pass              $proxy_uri;
            }
    
            location = / {
                return 301 /admin;
            }
        }
    
    
        server {
            server_name homeassistant.${var.domain};

            listen 443 ssl;
    
            keepalive_timeout   70;
            ssl_certificate     /etc/letsencrypt/live/${var.domain}/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/${var.domain}/privkey.pem;
            ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
            ssl_ciphers         HIGH:!aNULL:!MD5;
    
    
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
            #add_header X-Content-Type-Options nosniff;    # cannot apply now because of open keycloak issue https://issues.redhat.com/browse/KEYCLOAK-17076
            add_header X-XSS-Protection: "1; mode=block";
    
    
            location = /service_worker.js {
                return 404;
            }
    
            location / {
    #            default_type 'text/html';
    
                set $ssl_verify       no;
                set $redirect_uri     https://homeassistant.${var.domain}/login;
                set $discovery        https://auth.${var.domain}/auth/realms/home/.well-known/openid-configuration;
                set $client_id        ${var.homeassistant_client_id};
                set $client_secret    ${var.homeassistant_secret_id};
    
                access_by_lua_file /usr/local/openresty/nginx/conf/lua/authenticate.lua;
    
    
                proxy_set_header        Host $host;
                proxy_http_version      1.1;
                proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header        Upgrade $http_upgrade;
                proxy_set_header        Connection "upgrade";

                set $proxy_uri          http://192.168.1.11:8123;
                proxy_pass              $proxy_uri;
    
    #            proxy_hide_header       Cache-Control;
    #            add_header              Cache-Control "no-cache";
    
            }
        }
    
        server {
            server_name ${var.domain};
        
            client_max_body_size 500M;
     
            listen 443 ssl;
            ssl_certificate     /etc/letsencrypt/live/${var.domain}/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/${var.domain}/privkey.pem;
            ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
            ssl_ciphers         HIGH:!aNULL:!MD5;
    
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
            #add_header X-Content-Type-Options nosniff;    # cannot apply now because of open keycloak issue https://issues.redhat.com/browse/KEYCLOAK-17076
            add_header X-XSS-Protection: "1; mode=block";
    
            location / {
                proxy_buffering off;
                proxy_request_buffering off;
    
                proxy_set_header        Host $host;
                proxy_set_header        X-Real-IP $remote_addr;
                proxy_set_header        Referer $http_referer;
                proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header        X-Forwarded-Proto $scheme;
    
                set $proxy_uri          http://home-portal:8080;
                proxy_pass              $proxy_uri;
            }
        }
    
        server {
            if ($host = ${var.domain}) {
                return 301 https://$host$request_uri;
            }
    
            listen 80;
            server_name ${var.domain};
            return 404;
        }
    
        server {
            if ($host = auth.${var.domain}) {
                return 301 https://$host$request_uri;
            }
    
    
            listen 80;
            server_name auth.${var.domain};
            return 404;
        }
    
        server {
            if ($host = wiki.${var.domain}) {
                return 301 https://$host$request_uri;
            }
    
    
            listen 80;
            server_name wiki.${var.domain};
            return 404;
        }
    
        server {
            if ($host = nextcloud.${var.domain}) {
                return 301 https://$host$request_uri;
            }
    
            listen 80;
            server_name nextcloud.${var.domain};
            return 404;
        }
    
        server {
            if ($host = snipeit.${var.domain}) {
                return 301 https://$host$request_uri;
            }

            listen 80;
            server_name snipeit.${var.domain};
            return 404;
        }
    
        server {
            if ($host = vaultwarden.${var.domain}) {
               return 301 https://$host$request_uri;
            }
    
            listen 80;
            server_name vaultwarden.${var.domain};
            return 404;
        }
    
        server {
            if ($host = pihole.${var.domain}) {
                return 301 https://$host$request_uri;
            }
    
            listen 80;
            server_name pihole.${var.domain};
            return 404;
        }
    }
    EOT
}

