variable "aws_region" {
    description = "region of AWS"
    default = "us-east-1"
}

variable "lab_tag" {
    description = "tagging purposes for cost allocation"
    default = "labVPC"
}

variable "project" {
    description = "tagging purposes for cost allocation"
    default = "lab"
}
variable "lab_cidr"{
    description = "CIDR for VPC"
    default = "20.0.0.0/16"
}

variable "lab_public_subnet" {
    description = "public subnet for lab "
    default = "20.0.1.0/24"
}

variable "lab_private_subnet" {
    description = "private subnet for lab"
    default = "20.0.2.0/24"
}

