variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}(?:-[a-z0-9]+)+-[0-9]+$", var.region))
    error_message = "region must look like a valid AWS region, for example us-east-1 or us-gov-west-1."
  }
}

variable "project_name" {
  description = "Project name prefix for all resources"
  type        = string
  default     = "skylerblue"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,32}$", var.project_name))
    error_message = "project_name must contain 3-32 lowercase letters, numbers, or hyphens."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "environment must be development, staging, or production."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0)) && length(regexall(":", var.vpc_cidr)) == 0
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability zones used for public/private subnet pairs"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]

  validation {
    condition     = length(var.availability_zones) >= 2 && length(var.availability_zones) <= 6 && length(distinct(var.availability_zones)) == length(var.availability_zones)
    error_message = "availability_zones must contain 2-6 unique zones."
  }
}

variable "web_ingress_cidrs" {
  description = "IPv4 CIDRs allowed to reach the web security group"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition = length(var.web_ingress_cidrs) > 0 && alltrue([
      for cidr in var.web_ingress_cidrs : can(cidrhost(cidr, 0)) && length(regexall(":", cidr)) == 0
    ])
    error_message = "web_ingress_cidrs must contain at least one valid IPv4 CIDR."
  }
}

variable "enable_http_ingress" {
  description = "Whether to expose TCP/80 in addition to HTTPS"
  type        = bool
  default     = false
}
