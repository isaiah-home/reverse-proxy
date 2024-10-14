resource "docker_image" "goaccess" {
  name = "organize-me/goaccess"
  build {
    context    = "./goaccess/"

    build_arg  = var.maxmind_license_key != "" ? {
      MAXMIND_LICENSE_KEY = var.maxmind_license_key
    } : {}
  }

  triggers = {
    dockerfile = filemd5("./goaccess/Dockerfile")
    dockerfile = filemd5("./goaccess/download-geo.sh")
    dockerfile = filemd5("./goaccess/entrypoint.sh")
  }
}

resource "docker_container" "goaccess" {
  image        = docker_image.goaccess.image_id
  name         = "organize-me-goaccess"
  hostname     = "goaccess"
  restart      = "unless-stopped"
  network_mode = "bridge"

  volumes {
    volume_name = docker_volume.nginx_goaccess.name
    container_path = "/usr/local/goaccess"
  }

  networks_advanced {
    name    = data.docker_network.organize_me.name
    aliases = ["goaccess"]
  }
}
