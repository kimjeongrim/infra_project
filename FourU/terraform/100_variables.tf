variable "region" {
  description = "Seoul Region"
  type        = string
  default     = "ap-northeast-2"
}

variable "cidr" {
  description = "Vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "name" {
  description = "Vpc Name"
	default = "foryou"
	type = string
}