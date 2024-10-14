resource "docker_image" "goaccess" {
  name = "organize-me/goaccess"

  build {
    context = "./goaccess/"

    # Pass the build_arg unconditionally, but only set the value if the variable is not empty
    build_arg = {
      MAXMIND_LICENSE_KEY = var.maxmind_license_key
    }
  }

  triggers = {
    dockerfile = filemd5("./goaccess/Dockerfile")
    geo_script = filemd5("./goaccess/download-geo.sh")
    entrypoint = filemd5("./goaccess/entrypoint.sh")
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
