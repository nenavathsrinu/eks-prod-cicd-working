variable "vpc_cidr" {
    description = "The CIDR block for the VPC."
    type        = string
}

variable "public_subnets" {
    description = "A list of public subnet CIDR blocks."
    type        = list(string)
}

variable "private_subnets" {
    description = "A list of private subnet CIDR blocks."
    type        = list(string)
}

variable "azs" {
    description = "A list of availability zones."
    type        = list(string)
}

variable "cluster_name" {
    description = "The name of the cluster."
    type        = string
}

variable "tags" {
    description = "A map of tags to assign to resources."
    type        = map(string)
    default     = {}
}

