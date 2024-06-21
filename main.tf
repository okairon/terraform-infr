terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

variable "yc_token" {}

provider "yandex" {
  zone = "ru-central1-a"
  token = var.yc_token
}

resource "yandex_compute_instance" "default" {
  name        = "cluster"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  folder_id   = "b1gnr501vl8p8v9vt5ag"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.default.id

  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "default" {
  folder_id = "b1gnr501vl8p8v9vt5ag"
}

resource "yandex_vpc_subnet" "default" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["10.0.0.0/24"]
  folder_id      = "b1gnr501vl8p8v9vt5ag"
}

resource "yandex_compute_disk" "default" {
  name     = "disk-name"
  type     = "network-ssd"
  zone     = "ru-central1-a"
  size     = "30"
  image_id = "fd824arl9rjgb976kkb1" // идентификатор образа Ubuntu
  folder_id = "b1gnr501vl8p8v9vt5ag"
  
  labels = {
    environment = "test"
  }
}