# ============================================================
# main.tf - WITH INTENTIONAL VULNERABILITIES (Before AI Fix)
# Vulnerabilities:
#   1. SSH port 22 open to 0.0.0.0/0 (entire internet)
#   2. Root EBS volume is NOT encrypted
# These will be flagged by Trivy and fixed using AI
# ============================================================

provider "aws" {
  region = var.aws_region
}

# ----------------------------
# VPC
# ----------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "devops-vpc"
  }
}

# ----------------------------
# Public Subnet
# ----------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "devops-public-subnet"
  }
}

# ----------------------------
# Internet Gateway
# ----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "devops-igw"
  }
}

# ----------------------------
# Route Table
# ----------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "devops-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ----------------------------
# Security Group
# ❌ VULNERABILITY 1: SSH open to entire internet (0.0.0.0/0)
# ----------------------------
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  # ❌ BAD: SSH open to whole internet
  ingress {
    description = "SSH from anywhere - INSECURE"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow web traffic on port 5000
  ingress {
    description = "Flask app port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-web-sg"
  }
}

# ----------------------------
# EC2 Instance
# ❌ VULNERABILITY 2: Unencrypted root volume
# ----------------------------
resource "aws_instance" "web" {
  ami                    = "ami-0c02fb55956c7d316"   # Amazon Linux 2 (us-east-1)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # ❌ BAD: encrypted = false
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    encrypted   = false
  }

  # Install Docker and run app on startup
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -a -G docker ec2-user
              docker run -d -p 5000:5000 python:3.11-slim python -c "
              from http.server import HTTPServer, BaseHTTPRequestHandler
              class H(BaseHTTPRequestHandler):
                  def do_GET(self):
                      self.send_response(200)
                      self.end_headers()
                      self.wfile.write(b'Hello from DevSecOps App!')
              HTTPServer(('0.0.0.0', 5000), H).serve_forever()
              "
              EOF

  tags = {
    Name = "devops-web-server"
  }
}
