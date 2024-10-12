resource "docker_image" "goaccess" {
  name = "allinurl/goaccess:1.9.3"
}

resource "docker_container" "goaccess" {
  image        = docker_image.goaccess.image_id
  name         = "organize-me-goaccess"
  hostname     = "goaccess"
  restart      = "unless-stopped"
  network_mode = "bridge"

  command = [
    "-f", "/usr/local/goaccess/logs/access.log",
    "--log-format=COMBINED",
    "--real-time-html",
    "-o", "/usr/local/goaccess/html/index.html",
    "--persist",
    "--restore"
  ]

  volumes {
    volume_name = docker_volume.nginx_goaccess.name
    container_path = "/usr/local/goaccess"
  }

  networks_advanced {
    name    = data.docker_network.organize_me.name
    aliases = ["goaccess"]
  }
}
