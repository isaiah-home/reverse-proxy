resource "local_file" "log_nginx_conf" {
  filename = "${var.install_root}/nginx/etc/nginx/conf.d/home.conf"
    content = <<-EOT
      log_format custom '$remote_addr - $remote_user [$time_local] "$request" '
                        '$status $body_bytes_sent "$http_referer" '
                        '"$http_user_agent" "$host"';

      access_log /usr/local/openresty/nginx/logs/access.log custom;
    EOT
}