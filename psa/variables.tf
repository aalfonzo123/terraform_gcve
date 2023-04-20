variable "project_id" {
  type = string
}

variable "customer_vpc" {
  type = string
}

variable "psa_address_range" {
  type = object({
    name          = string
    address       = string
    prefix_length = string
  })
}

