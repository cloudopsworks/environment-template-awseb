variable "region" {
  type    = string
  default = "us-east-1"
}

variable "application_name" {
  type = string
}

variable "release_name" {
  type = string
}

variable "source_name" {
  type = string
}

variable "source_version" {
  type = string
}

variable "solution_stack" {
  type = string

  validation {
    condition     = contains(keys(local.solutions), var.solution_stack)
    error_message = "Incorrect value for solution_stack."
  }
}