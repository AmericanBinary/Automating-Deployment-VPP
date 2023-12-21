
# GCP Provider Configuration
provider "google" {
  project = "your-gcp-project-id"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# VPC Network (similar to azurerm_virtual_network)
resource "google_compute_network" "vpc_network" {
  name                    = "gcp-vpc-network"
  auto_create_subnetworks = false # We'll define subnetworks manually
}

# Subnets (similar to azurerm_subnet)
resource "google_compute_subnetwork" "subnet_mgmt" {
  name          = "subnet-mgmt"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "subnet_vpp" {
  name          = "subnet-vpp"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
}

# Public IP (similar to azurerm_public_ip)
resource "google_compute_address" "public_ip" {
  name   = "gcp-public-ip"
  region = "us-central1"
}

# Firewall Rules (similar to azurerm_network_security_group)
resource "google_compute_firewall" "firewall" {
  name    = "gcp-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Compute Instance (similar to azurerm_virtual_machine)
resource "google_compute_instance" "vm_instance" {
  name         = "gcp-vm-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-bionic-v20210817"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_mgmt.name

    access_config {
      // Ephemeral public IP
      nat_ip = google_compute_address.public_ip.address
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  tags = ["http-server", "https-server"]
}

# Additional resources like NICs, route tables, etc., can be configured as needed
