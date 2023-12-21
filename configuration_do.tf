
# Digital Ocean Provider Configuration
provider "digitalocean" {
  # Add your Digital Ocean token here
  token = "YOUR_DO_TOKEN"
}

# Digital Ocean VPC (similar to aws_vpc)
resource "digitalocean_vpc" "do_vpc" {
  name        = "do-vpc"
  region      = "nyc3"
  ip_range    = "10.11.0.0/16"
}

# Digital Ocean Subnets (similar to aws_subnet)
resource "digitalocean_vpc_subnet" "do_subnet_vpp" {
  vpc_id      = digitalocean_vpc.do_vpc.id
  ip_range    = "10.11.1.0/24"
}

resource "digitalocean_vpc_subnet" "do_subnet_management" {
  vpc_id      = digitalocean_vpc.do_vpc.id
  ip_range    = "10.11.2.0/24"
}

# Digital Ocean does not support IPv6 in the same manner as AWS
# The ipv6 subnet will be omitted in the Digital Ocean configuration

# Digital Ocean Firewall (similar to aws_security_group)
resource "digitalocean_firewall" "do_firewall_allow_all" {
  name = "allow-all"

  inbound_rule {
    protocol    = "tcp"
    port_range  = "1-65535"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol        = "tcp"
    port_range      = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Attach the firewall to the droplets
  droplet_ids = [digitalocean_droplet.do_instance_vpp.id]
}

# Digital Ocean Droplet (similar to aws_instance)
resource "digitalocean_droplet" "do_instance_vpp" {
  image  = "ubuntu-20-04-x64"
  name   = "do-instance-vpp"
  region = "nyc3"
  size   = "s-1vcpu-2gb"
  private_networking = true
  ssh_keys = [digitalocean_ssh_key.do_ssh_key.id]

  # Assign it to the management subnet
  vpc_uuid = digitalocean_vpc.do_vpc.id
}

# Digital Ocean SSH Key (to replace aws_key_pair)
resource "digitalocean_ssh_key" "do_ssh_key" {
  name       = "do_ssh_key"
  public_key = "ssh-rsa YOUR_SSH_PUBLIC_KEY"
}

# Digital Ocean does not have a direct equivalent of AWS Network Interface or EIP.
# These components are omitted in the Digital Ocean configuration.
