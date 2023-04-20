provider "google" {
  project = var.project_id
}

data "google_compute_network" "customer-vpc-full" {
  name = var.customer_vpc
}

resource "google_compute_global_address" "private_ip_address" {
  name          = var.psa_address_range.name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.psa_address_range.prefix_length
  address       = var.psa_address_range.address
  network       = data.google_compute_network.customer-vpc-full.id
}

resource "google_service_networking_connection" "default" {
  network                 = data.google_compute_network.customer-vpc-full.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
  peering = google_service_networking_connection.default.peering
  network = var.customer_vpc

  import_custom_routes = true
  export_custom_routes = true
}

data "google_compute_network_peering" "psa_peering" {
  name    = google_service_networking_connection.default.peering
  network = data.google_compute_network.customer-vpc-full.id
}

data "google_project" "project" {
  project_id = var.project_id
}

output "peer_project_id" {
  value = data.google_project.project.project_id
}

output "peer_project_number" {
  value = data.google_project.project.number
}

output "tenant_project_id" {
  value = split("/", data.google_compute_network_peering.psa_peering.peer_network)[6]
}
output "peer_vpc_id" {
  value = var.customer_vpc
}

