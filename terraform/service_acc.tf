#создание сервисного аккаунта
resource "yandex_iam_service_account" "sa" {
  name        = "service"
  description = "сервисный аккаунт"
  folder_id   = yandex_resourcemanager_folder.default.id
}

#назначение ролей сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id   = yandex_resourcemanager_folder.default.id
  role        = "k8s.clusters.agent"
  member      = "serviceAccount:${yandex_iam_service_account.sa.id}"
}
resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  # Сервисному аккаунту назначается роль "vpc.publicAdmin".
  folder_id = yandex_resourcemanager_folder.default.id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = yandex_resourcemanager_folder.default.id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  # Сервисному аккаунту назначается роль "kms.keys.encrypterDecrypter".
  folder_id = yandex_resourcemanager_folder.default.id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}