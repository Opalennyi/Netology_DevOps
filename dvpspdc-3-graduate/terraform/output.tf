output "main_instance_external_ip_address" {
  value = yandex_compute_instance.main.network_interface.0.nat_ip_address
}

output "db01_internal_ip_address" {
  value = yandex_compute_instance.db01.network_interface.0.ip_address
}

output "db02_internal_ip_address" {
  value = yandex_compute_instance.db02.network_interface.0.ip_address
}

output "app_internal_ip_address" {
  value = yandex_compute_instance.app.network_interface.0.ip_address
}

output "monitoring_internal_ip_address" {
  value = yandex_compute_instance.monitoring.network_interface.0.ip_address
}

output "gitlab_internal_ip_address" {
  value = yandex_compute_instance.gitlab.network_interface.0.ip_address
}

output "runner_internal_ip_address" {
  value = yandex_compute_instance.runner.network_interface.0.ip_address
}

output "ssh_config" {
  value = <<-EOT
  Host sergey-belov.ru
    HostName ${yandex_compute_instance.main.network_interface.0.nat_ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa

  Host db01.sergey-belov.ru
    HostName ${yandex_compute_instance.db01.network_interface.0.ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
      ProxyJump ubuntu@${yandex_compute_instance.nat.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host db02.sergey-belov.ru
    HostName ${yandex_compute_instance.db02.network_interface.0.ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
      ProxyJump ubuntu@${yandex_compute_instance.nat.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host app.sergey-belov.ru
    HostName ${yandex_compute_instance.app.network_interface.0.ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
      ProxyJump ubuntu@${yandex_compute_instance.nat.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host monitoring.sergey-belov.ru
    HostName ${yandex_compute_instance.monitoring.network_interface.0.ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
      ProxyJump ubuntu@${yandex_compute_instance.nat.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host gitlab.sergey-belov.ru
    HostName ${yandex_compute_instance.gitlab.network_interface.0.ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
      ProxyJump ubuntu@${yandex_compute_instance.nat.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host runner.sergey-belov.ru
    HostName ${yandex_compute_instance.runner.network_interface.0.ip_address}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
      ProxyJump ubuntu@${yandex_compute_instance.nat.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  EOT
}