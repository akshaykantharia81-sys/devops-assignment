# 🚀 DevSecOps Assignment - GET 2026

## Project Overview
This project demonstrates a complete DevSecOps pipeline:
- A Python Flask web app containerized with Docker
- AWS infrastructure provisioned with Terraform
- Jenkins CI/CD pipeline with automated security scanning (Trivy)
- AI-driven vulnerability detection and remediation

---

## 🏗️ Architecture

```
GitHub Repo
    │
    ▼
Jenkins Pipeline
    ├── Stage 1: Checkout (pull code)
    ├── Stage 2: Trivy Security Scan (scan Terraform)
    └── Stage 3: Terraform Plan
            │
            ▼
        AWS Cloud
        ├── VPC + Subnet
        ├── Security Group
        └── EC2 Instance (t2.micro)
                │
                ▼
        Docker Container
        └── Flask App (port 5000)
```

---

## ☁️ Cloud Provider
**Amazon Web Services (AWS)**
- Region: us-east-1
- EC2: t2.micro (Free Tier)

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| Python + Flask | Web application |
| Docker + Docker Compose | Containerization |
| Terraform | Infrastructure as Code |
| AWS | Cloud provider |
| Jenkins | CI/CD Pipeline |
| Trivy | Security scanning |
| Claude AI | Vulnerability analysis & fix |
| GitHub | Source code repository |

---

## 📁 Project Structure

```
devops-assignment/
├── app/
│   ├── app.py                   # Flask web application
│   ├── requirements.txt         # Python dependencies
│   ├── Dockerfile               # Docker image definition
│   └── docker-compose.yml       # Local Docker setup
├── terraform/
│   ├── main.tf                  # AWS infrastructure (secured)
│   ├── variables.tf             # Input variables
│   └── outputs.tf               # Output values
├── jenkins/
│   └── Jenkinsfile              # CI/CD pipeline definition
└── README.md                    # This file
```

---

## 🔐 Security: Before & After

### ❌ Before (Vulnerable)
```hcl
# SSH open to entire internet
ingress {
  from_port   = 22
  cidr_blocks = ["0.0.0.0/0"]   # VULNERABLE
}

# Unencrypted disk
root_block_device {
  encrypted = false              # VULNERABLE
}
```

### ✅ After (Fixed with AI help)
```hcl
# SSH restricted to my IP only
ingress {
  from_port   = 22
  cidr_blocks = ["MY_IP/32"]    # FIXED
}

# Encrypted disk
root_block_device {
  encrypted = true               # FIXED
}
```

---

## 🤖 AI Usage Log

### Prompt Used:
> "Here is my Trivy security scan report for Terraform code: [pasted report].
> Please:
> 1. Explain each vulnerability and the risk it poses
> 2. Rewrite the Terraform code to fix all issues securely"

### Vulnerabilities Identified by AI:
1. **SSH open to 0.0.0.0/0** — Risk: Anyone on the internet can attempt to brute-force SSH login
2. **Unencrypted EBS volume** — Risk: If AWS disk is accessed physically or via snapshot, data is readable

### How AI Fixes Improved Security:
- SSH is now restricted to my specific IP (`/32` CIDR)
- Root volume encryption enabled, protecting data at rest

---

## 🌐 Live Application
**App URL:** http://YOUR_EC2_PUBLIC_IP:5000

---

## ▶️ How to Run Locally

```bash
# 1. Clone repo
git clone https://github.com/YOUR_USERNAME/devops-assignment.git
cd devops-assignment

# 2. Run the web app
cd app
docker-compose up --build
# Visit http://localhost:5000

# 3. Start Jenkins
docker run -d --name jenkins \
  -p 8080:8080 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
# Visit http://localhost:8080
```

---

## 📸 Screenshots
- `screenshots/jenkins-fail.png` — Initial failing pipeline (vulnerability found)
- `screenshots/jenkins-pass.png` — Fixed pipeline passing
- `screenshots/trivy-report.png` — Trivy vulnerability report
- `screenshots/app-running.png` — App on cloud public IP
