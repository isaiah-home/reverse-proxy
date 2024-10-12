# Passwords are not managed by terraform, but to mount the volume the directory must already exist
resource "null_resource" "create_htpasswd" {
  provisioner "local-exec" {
    command = "mkdir -p ${var.install_root}/nginx/etc/nginx/htpasswd"
  }
}

resource "docker_image" "nginx" {
  name         = "organize-me/nginx"
  build {
    context = "../"
    dockerfile = "../Dockerfile"
  }
  triggers = {
    nginx_conf = filemd5("../nginx.conf")
  }
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
    "HOME_CONFIG_MD5=${local_file.home_nginx_conf.content_md5}",
    "BUILD_CONFIG_MD5=${local_file.build_nginx_conf.content_md5}",
    "LOG_CONFIG_MD5=${local_file.base_nginx_conf.content_md5}"
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
    null_resource.create_htpasswd_registry,
    local_file.home_nginx_conf,
    local_file.build_nginx_conf
  ]
}
