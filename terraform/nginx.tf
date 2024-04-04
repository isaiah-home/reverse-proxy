resource "docker_image" "nginx" {
  name         = "organize-me/nginx"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image         = docker_image.nginx.image_id
  name          = "organize-me-nginx"
  hostname      = "nginx"
  restart       = "unless-stopped"
#  wait         = true
#  wait_timeout = 300 # 5 minutes
  
  env=[
    "HOME_CONFIG_MD5=${local_file.home_nginx_conf.content_md5}",
    "BUILD_CONFIG_MD5=${local_file.build_nginx_conf.content_md5}"
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
  volumes {
    host_path      = "${var.install_root}/nginx/etc/nginx/conf.d"
    container_path = "/etc/nginx/conf.d"
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
    local_file.home_nginx_conf,
    local_file.build_nginx_conf
  ]
}
