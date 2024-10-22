variable "location" {
    default = "eastus"
    description = "The location we are deploying our resources"
}
variable "evironment" {
  type = string
  description = "Production or Development Environment"
  validation {
    condition = length(var.evironment) <= 4 && (substr(var.environment, 0, 3) == "DEV" || substr(var.environment, 0,4) == "PROD")
    error_message = "The environment value must be either PROD or DEV"
  }
}

