
# Digital Ocean Provider Configuration
provider "digitalocean" {
  # Add your Digital Ocean token here
  token = "YOUR_DO_TOKEN"
}

# Define your variables here based on the VPP scenario

# Creating a VPC
resource "digitalocean_vpc" "vpp_vpc" {
  # Replace with your desired VPC name and region
  name     = "vpp-vpc"
  region   = "nyc3"
  # Replace with the VPC CIDR block from the VPP scenario
  ip_range = "10.0.0.0/16"
}

#  Creating a Subnet
resource "digitalocean_subnet" "vpp_subnet" {
  # Replace with your desired Subnet name and region
  vpc_uuid  = digitalocean_vpc.vpp_vpc.id
  region    = "nyc3"
  # Replace with the Subnet CIDR block from the VPP scenario
  ip_range  = "10.0.1.0/24"
  # Define additional subnet properties as needed
}
