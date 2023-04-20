locals {
  transformed = toset(flatten([for k, v in var.services_to_enable : [for s in v : "${k}|${s}"]]))
}

resource "google_project_service" "project_services" {
  for_each = local.transformed
  project  = split("|", each.value)[0]
  service  = split("|", each.value)[1]
}