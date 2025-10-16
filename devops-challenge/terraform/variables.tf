variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}


variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "devops-challenge"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "EC2 key pair name for SSH"
  type        = string
}

variable "my_ip" {
  description = "Your public IP in CIDR format for SSH access"
  type        = string
  default     = "203.0.113.25/32"
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, production)"
  type        = string
  default     = "production"
}

variable "ebs_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}

variable "ebs_volume_type" {
  description = "Type of EBS volume"
  type        = string
  default     = "gp3"
}

variable "ebs_encrypted" {
  description = "Whether the root EBS volume is encrypted"
  type        = bool
  default     = true
}


variable "health_check_path" {
  description = "The path for the load balancer health check"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Interval (in seconds) between health checks"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Timeout (in seconds) for each health check attempt"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of consecutive successful checks before a target is considered healthy"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed checks before a target is considered unhealthy"
  type        = number
  default     = 2
}

variable "health_check_matcher" {
  description = "HTTP code(s) that indicate a healthy response"
  type        = string
  default     = "200"
}
