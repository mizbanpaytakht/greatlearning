variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_security_group_app_server" {
    description = "Port Lists to open for AppServer"
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      description = string
    }))
    default     = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          description = "SSH Port"
        },
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          description = "HTTP Port"
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          description = "HTTPs Port"
        },
        {
          from_port   = 8065
          to_port     = 8065
          protocol    = "tcp"
          description = "Custom Port"
        },
    ]
}



variable "aws_security_group_db_server" {
    description = "Port Lists to open for DBServer"
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      description = string
    }))
    default     = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          description = "SSH Port"
        },
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          description = "HTTP Port"
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          description = "HTTPs Port"
        },
        {
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          description = "MySQL Port"
        },
    ]
}