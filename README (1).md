# DevSecOps Assignment - GET 2026

## About This Project

This project was built as part of a DevSecOps assignment. The goal was to containerize a web app, provision cloud infrastructure using Terraform, set up a Jenkins CI/CD pipeline with security scanning, and use AI to identify and fix security vulnerabilities.

I used Python Flask for the web app, Docker to containerize it, Terraform to provision AWS infrastructure, Jenkins for the pipeline, and Trivy for security scanning.

---

## Cloud Provider
**AWS (Amazon Web Services)** — us-east-1 region

## Live App
**http://44.223.9.112:5000**

---

## Tools Used

- Python + Flask — web application
- Docker + Docker Compose — containerization
- Terraform — infrastructure as code
- AWS EC2 — cloud server
- Jenkins — CI/CD pipeline
- Trivy — security scanning
- Claude AI — vulnerability analysis and fix
- GitHub — source control

---

## Project Structure

```
devops-assignment/
├── app/
│   ├── app.py
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── requirements.txt
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── jenkins/
│   └── Jenkinsfile
└── README.md
```

---

## How to Run Locally

```bash
# Clone the repo
git clone https://github.com/akshaykantharia81-sys/devops-assignment.git
cd devops-assignment

# Run the app
cd app
docker-compose up --build

# Visit http://localhost:5000
```

---

## Jenkins Pipeline

The pipeline has 3 stages:

1. **Checkout** - pulls code from GitHub
2. **Security Scan** - runs Trivy on Terraform files
3. **Terraform Plan** - previews AWS infrastructure changes

---

## Security: Before and After

### Before (Vulnerable Code)
When I first wrote the Terraform code, it had these issues:

```hcl
# SSH open to entire internet - bad
ingress {
  from_port   = 22
  cidr_blocks = ["0.0.0.0/0"]
}

# Disk not encrypted
root_block_device {
  encrypted = false
}
```

Trivy found 5 vulnerabilities — 1 CRITICAL and 4 HIGH severity issues.

### After (Fixed Code)
After using AI to analyze the report and fix the issues:

```hcl
# SSH restricted to internal VPC only
ingress {
  from_port   = 22
  cidr_blocks = ["10.0.0.0/16"]
}

# Disk encrypted
root_block_device {
  encrypted = true
}
```

Trivy scan passed with 0 vulnerabilities.

---


---

## AI Usage Log

**Tool used:** Claude AI (claude.ai)

**Prompt I used:**
> "Here is my Trivy security scan report for Terraform code. Please explain each vulnerability, the risk it poses, and fix the Terraform code to resolve all issues."

**Vulnerabilities found by AI:**

1. SSH port 22 open to 0.0.0.0/0 — anyone on the internet could try to brute force login
2. EBS root volume not encrypted — data could be read if disk is accessed
3. Unrestricted egress to internet — server could send data anywhere
4. IMDS v2 token not required — metadata service could be exploited
5. Subnet auto-assigns public IPs — resources unnecessarily exposed

**How AI helped fix it:**

- Restricted SSH to internal VPC CIDR (10.0.0.0/16) only
- Set encrypted = true on the root block device
- Restricted egress traffic to internal VPC only
- Added metadata_options block with http_tokens = required
- Set map_public_ip_on_launch = false on the subnet

---

## Video Demo

Watch the full pipeline demo here:
**https://youtu.be/WGUCN12cc38**

The video shows:
- Jenkins pipeline failing with security vulnerabilities
- AI conversation used to fix the issues
- Jenkins pipeline passing with 0 vulnerabilities
- App running live on AWS public IP
