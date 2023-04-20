variable "services_to_enable" {
  type        = map(list(string))
  description = "map in which keys are project_ids and values are a list of services to enable on that project"
}