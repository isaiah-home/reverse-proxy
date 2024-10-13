# Passwords are not managed by terraform, but to mount the volume the directory must already exist
resource "null_resource" "create_htpasswd" {
  provisioner "local-exec" {
    command = "mkdir -p ${var.install_root}/nginx/etc/nginx/htpasswd"
  }
}

resource "docker_image" "nginx" {
  name         = "organize-me/nginx"
  build {
    context    = "openresty/"
    dockerfile = "openresty/Dockerfile"
  }

  triggers = {
    dockerfile   = filemd5("openresty/Dockerfile")
    nginx_conf   = filemd5("openresty/nginx.conf")
    authenticate = filemd5("openresty/lua/authenticate.lua")
  }
}

resource "docker_volume" "nginx_goaccess" {
  name = "nginx_goaccess"
}

resource "docker_container" "nginx" {
  image         = docker_image.nginx.image_id
  name          = "organize-me-nginx"
  hostname      = "nginx"
  restart       = "unless-stopped"
  network_mode  = "bridge"
#  wait         = true
#  wait_timeout = 300 # 5 minutes

  env=[
#    "HOME_CONFIG_MD5=${local_file.home_nginx_conf.content_md5}",
#    "BUILD_CONFIG_MD5=${local_file.build_nginx_conf.content_md5}",
    "BASE_CONFIG_MD5=${local_file.base_nginx_conf.content_md5}"
  ]

  networks_advanced {
    name    = data.docker_network.organize_me.name
    aliases = ["nginx"]
  }
  ports {
    external = 80
    internal = 80
  }
  ports {
    external = 443
    internal = 443
  }
  ports {
    external = 7890
    internal = 7890
  }

  volumes {
    volume_name    = docker_volume.nginx_goaccess.name
    container_path = "/usr/local/goaccess"
  }
  volumes {
    host_path      = "${var.install_root}/nginx/etc/nginx/conf.d"
    container_path = "/etc/nginx/conf.d"
    read_only      = true
  }
  volumes {
    host_path      = "${var.install_root}/nginx/etc/nginx/htpasswd"
    container_path = "/etc/nginx/htpasswd"
    read_only      = true
  }
  volumes {
    host_path      = "${var.install_root}/letsencrypt/etc/letsencrypt"
    container_path = "/etc/letsencrypt"
    read_only      = true
  }
  volumes {
    host_path      = "${var.install_root}/letsencrypt/var/lib/letsencrypt"
    container_path = "/var/lib/letsencrypt"
    read_only      = true
  }

  labels {
    label = "project"
    value = "iv-buildsystem"
  }
  
  depends_on = [
    null_resource.create_htpasswd,
#    null_resource.create_htpasswd_registry,
#    local_file.home_nginx_conf,
#    local_file.build_nginx_conf
  ]
}
