variable "install_root" {
  type = string
}

variable "docker_host" {
  type = string
  default = "unix:///var/run/docker.sock"
}

variable "docker_network" {
  type = string
  default = "organize_me_network"
}

# home domain
variable "domain" {
  type = string
}

# build-system domain
variable "domain_build" {
  type = string
}

# Pi-hole
variable "pihole_client_id" {
  type = string
  sensitive = true
}
variable "pihole_secret_id" {
  type = string
  sensitive = true
}

# Home Assistant
variable "homeassistant_client_id" {
  type = string
  sensitive = true
}
variable "homeassistant_secret_id" {
  type = string
  sensitive = true
}

# GoAccess
variable "goaccess_client_id" {
  type = string
  sensitive = true
}
variable "goaccess_secret_id" {
  type = string
  sensitive = true
}
