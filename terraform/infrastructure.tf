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

resource "yandex_resourcemanager_folder" "default" {
  cloud_id = "b1g9jo4h5to9j40u8c81"
  name        = "terraform-infra"
  description = ""
}

resource "yandex_vpc_network" "default" {
  folder_id = yandex_resourcemanager_folder.default.id
}

resource "yandex_vpc_subnet" "main" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["10.0.16.0/24"]
  folder_id      = yandex_resourcemanager_folder.default.id
}

resource "yandex_vpc_subnet" "db" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["10.0.17.0/24"]
  folder_id      = yandex_resourcemanager_folder.default.id
}

resource "yandex_compute_instance" "vm" {
  name        = "vm"
  zone        = "ru-central1-a"
  folder_id = yandex_resourcemanager_folder.default.id
  

  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    disk_id = yandex_compute_disk.vm.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main.id
    nat       = true
  }


  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_disk" "vm" {
  name     = "vmdisk"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = "fd8oc4qnq5kg274e0vbn"
  folder_id = yandex_resourcemanager_folder.default.id
  size = 30
}