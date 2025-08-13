# project variables
variable "project_name" {
    type = string
}

variable "environment" {
    type = string
    default = "dev"
}

variable "common_tags" {
    type = map
}

### vpc ###
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    default = true
}

variable "vpc_tags" {
    type = map
    default = {}
}

### igw ###
variable "igw_tags" {
    type = map
    default = {}
}

### public subnet ###
variable "public_subnet_tags" {
    type = map
    default = {}
}

variable "public_subnet_cidrs" {
    validation {
        condition = length(var.public_subnet_cidrs) == 2
        error_message = "please provide 2 public subnet cidrs"
    }
}

### private subnet ###
variable "private_subnet_tags" {
    type = map
    default = {}
}

variable "private_subnet_cidrs" {
    validation {
        condition = length(var.private_subnet_cidrs) == 2
        error_message = "please provide 2 private subnet cidrs"
    }  
}

### database private subnet ###
variable "database_subnet_tags" {
    type = map
    default = {}
}

variable "database_subnet_cidrs" {
    validation {
        condition = length(var.database_subnet_cidrs) == 2
        error_message = "please provide 2 database subnet providers"
    }
}

## db subnet group ##
variable "db_subnet_group_tags" {
    type = map
    default = {}
}

### nat gateway ###
variable "nat_gw_tags" {
    type = map
    default = {}
}

### public route ###
variable "public_route_tags" {
    type = map
    default = {}
}

### private route ###
variable "private_route_tags" {
    type = map
    default = {}
}

### database route ###
variable "database_route_tags" {
    type = map
    default = {}
}

### vpc peering ###
variable "is_peering_required" {
    type = bool
    default = false
}

variable "peer_tags" {
    type = map
    default = {}
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
}