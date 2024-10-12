resource "local_file" "base_nginx_conf" {
  filename = "${var.install_root}/nginx/etc/nginx/conf.d/_base.conf"
  content  = <<-EOT
    # GoAccess
    server {
        server_name goaccess.${var.domain};;

        listen 443 ssl;
        ssl_certificate     /etc/letsencrypt/live/${var.domain}/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/${var.domain}/privkey.pem;
        ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
        ssl_ciphers         HIGH:!aNULL:!MD5;

        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        #add_header X-Content-Type-Options nosniff;    # cannot apply now because of open keycloak issue https://issues.redhat.com/browse/KEYCLOAK-17076
        add_header X-XSS-Protection: "1; mode=block";

        # Serve static files from the web directory
        location / {
            default_type 'text/html';

            set $ssl_verify       no;
            set $redirect_uri     https://pihole.${var.domain}/login;
            set $discovery        https://auth.${var.domain}/auth/realms/home/.well-known/openid-configuration;
            set $client_id        ${var.goaccess_client_id};
            set $client_secret    ${var.goaccess_secret_id};

            access_by_lua_file /usr/local/openresty/nginx/conf/lua/authenticate.lua;

            root /usr/local/openresty/nginx/html;  # Path to your web directory
            index index.html index.htm;            # Default index files
            try_files $uri $uri/ =404;             # Serve files or return 404 if not found
        }
    }
  EOT
}
