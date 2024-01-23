variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "enable_dns_hostnames" {
    type = bool
    default = true
}

variable "common_tags" {
  type = map 
  default = {
    Project_name = "roboshop"
    Environment = "dev"
    Terraform = true
  }
}

variable "aws_vpc_tags" {
  default = {}
}

variable "project_name" {
    type = string
}

variable "environment" {
  type = string
}

variable "aws_internet_gateway_tags" {
  default = {}
}

variable "public_vpc_cidr" {
    type = list 
    validation {
      condition = length(var.public_vpc_cidr) == 2
      error_message = "Please provide only 2 cidr values "
    }
  
}

variable "aws_public_subnet_tags" {
  default = {}
}

variable "private_vpc_cidr" {
    type = list 
    validation {
      condition = length(var.private_vpc_cidr) == 2
      error_message = "Please provide only 2 cidr values "
    }
  
}

variable "aws_private_subnet_tags" {
  default = {}
}

variable "database_vpc_cidr" {
    type = list 
    validation {
      condition = length(var.database_vpc_cidr) == 2
      error_message = "Please provide only 2 cidr values "
    }
  
}

variable "aws_database_subnet_tags" {
  default = {}
}

variable "aws_nat_gateway_tags" {
  default = {}
}

variable "aws_public_route_table_tags" {
  default = {}
}

variable "aws_private_route_table_tags" {
  default = {}
}

variable "aws_database_route_table_tags" {
  default = {}
}

variable "is_peering_required" {
  type = bool
  default = false
}

variable "acceptors_vpc_id" {
  type = string
  default = ""
}

variable "aws_vpc_peering_connection_tags" {
  default = {}
}