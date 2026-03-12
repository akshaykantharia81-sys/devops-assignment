variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "your_ip" {
  description = "Your local machine IP for SSH access (e.g. 123.456.789.0/32)"
  default     = "0.0.0.0/0"   # ⚠️ CHANGE THIS to your IP after AI remediation
}
