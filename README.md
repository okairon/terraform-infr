# terraform-infr
___
Тестовый репозиторий, пример работы с Yandex Cloud / Terraform / Managed Kubernetes / Apache Airflow для выполнения ТЗ по собеседованию.
___
## Основные задачи:
 - Используя Terraform (провайдер на выбор), создать базовую инфраструктуру. - Done
 - В созданной инфраструктуре развернуть кластер Kubernetes с помощью сервиса Managed Kubernetes (название может отличаться в зависимости от провайдера). - Done
 - В кластере Kubernetes развернуть Apache Airflow (Helm). - Done (есть проблемы с зауском пода с web-server, разбираюсь)
 - В другой подсети развернуть БД любую. - не готово
 - Создать и запустить любой DAG с записью БД. - не готово

## Как запустить проект:

Установите terraform:
    https://developer.hashicorp.com/terraform/install
    https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli?in=terraform%2Faws-get-started

Клонируйте репозиторий, перейдите в директорию /terraform проекта и вполните инициализацию terraform:
    - cd terraform-infr/terraform
    - terraform init

Выполните запуск изменений:
    - terraform apply
