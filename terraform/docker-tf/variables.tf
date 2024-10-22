variable "location" {
    default = "eastus"
    description = "The location we are deploying our resources"
}
variable "evironment" {
  type = string
  description = "Prod or Dev"
  validation {
    condition = value(var.evironment) != "PROD" || value(var.environment) != "DEV"
    error_message = "The environment value mist be either PROD or DEV"
  }
}
