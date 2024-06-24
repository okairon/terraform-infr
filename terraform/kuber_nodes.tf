resource "yandex_kubernetes_node_group" "airflow" {
  cluster_id  = yandex_kubernetes_cluster.k8s-zonal.id
  name        = "airflow"
  description = "Группа для ноды с apache-airflow"
  version     = "1.27"

  instance_template {
    platform_id = "standard-v1"

    metadata = {
      "ssh-keys" = file("~/.ssh/id_ed25519.pub")
    }

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.main.id]
      security_group_ids = [yandex_vpc_security_group.zonal-k8s-sg.id]
    }

    resources {
      memory = 2
      core_fraction = 20
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "1h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "1h"
    }
  }
}

resource "yandex_kubernetes_node_group" "psql" {
  cluster_id  = yandex_kubernetes_cluster.k8s-zonal.id
  name        = "psql"
  description = "Группа для нод с psql"
  version     = "1.27"
  

  instance_template {
    platform_id = "standard-v1"
    network_acceleration_type = "standard"

    metadata = {
      "ssh-keys" = file("~/.ssh/id_ed25519.pub")
    }

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.db.id]
      security_group_ids = [yandex_vpc_security_group.zonal-k8s-sg.id]
    }

    resources {
      memory = 2
      core_fraction = 20
      cores  = 2
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "12:00"
      duration   = "1h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "11:00"
      duration   = "1h"
    }
  }
}

resource "yandex_kubernetes_node_group" "ha-proxy" {
  cluster_id  = yandex_kubernetes_cluster.k8s-zonal.id
  name        = "ha-proxy"
  description = "Группа для ноды ha-proxy"
  version     = "1.27"
  

  instance_template {
    platform_id = "standard-v1"
    network_acceleration_type = "standard"

    metadata = {
      "ssh-keys" = file("~/.ssh/id_ed25519.pub")
    }

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.db.id]
      security_group_ids = [yandex_vpc_security_group.zonal-k8s-sg.id]
    }

    resources {
      memory = 2
      core_fraction = 20
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "12:00"
      duration   = "1h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "11:00"
      duration   = "1h"
    }
  }
}