resource "yandex_kubernetes_cluster" "k8s-zonal" {
  name = "k8s-zonal"
  network_id = yandex_vpc_network.default.id
  folder_id = yandex_resourcemanager_folder.default.id
  
  master {
    master_location {
      zone      = yandex_vpc_subnet.main.zone
      subnet_id = yandex_vpc_subnet.main.id
    }
    security_group_ids = [yandex_vpc_security_group.zonal-k8s-sg.id]
    etcd_cluster_size = "1"
    public_ip = true
  }
  service_account_id      = yandex_iam_service_account.sa.id
  node_service_account_id = yandex_iam_service_account.sa.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
}