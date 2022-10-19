terraform {
  cloud {
    organization = "netology-dvpspdc-3-graduate"
    workspaces {
      name = "dvpspdc-3-graduate"
    }
  }
}

resource "yandex_compute_instance" "nat" {
  name     = "nat"
  hostname = "nat.sergey-belov.ru"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8josjq21d56924jfan"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_vpc_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "main" {
  name = "main"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "db01" {
  name = "db01"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "db02" {
  name = "db02"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "app" {
  name = "wordpress"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "gitlab" {
  name = "gitlab"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "runner" {
  name = "runner"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

resource "yandex_compute_instance" "monitoring" {
  name = "monitoring"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}