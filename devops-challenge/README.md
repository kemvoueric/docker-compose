# DevOps Technical Challenge – Flask App Deployment on AWS

## Project Overview
This project automates the deployment of a Dockerized Flask web application on AWS EC2 using Terraform and a GitHub Actions CI/CD pipeline.

When you run `terraform apply`, the infrastructure is automatically provisioned:
1. Creates a security group that allows inbound HTTP (port 80) and restricts SSH access to your IP.
2. Launches a t3.micro EC2 instance running Amazon Linux 2.
3. Executes a `user_data.sh` script that installs Docker and runs the Flask container.
4. Creates an Application Load Balancer (ALB) that routes HTTP traffic to the EC2 instance.
5. Outputs the instance Public IP, DNS, and ALB URL.

---

## Project Structure
devops-challenge/
├── app/
│ ├── app.py # Flask app with /info endpoint
│ ├── Dockerfile # Builds Flask container
│
├── terraform/
│ ├── main.tf # EC2 instance, ALB, IAM roles, Security Groups
│ ├── provider.tf # AWS provider configuration
│ ├── variables.tf # Input variables (region, key pair, etc.)
│ ├── outputs.tf # Terraform outputs (IP/DNS)
│ └── user_data.sh # Bash script to install Docker & run Flask
│
└── .github/
└── workflows/
└── deploy.yml # GitHub Actions CI/CD workflow

yaml
Copy code

---

## Prerequisites
- Terraform v1.x or later installed  
- Docker Desktop installed  
- AWS account (Free Tier eligible)  
- AWS CLI configured locally (`aws configure`)  
- GitHub account with this repository forked or cloned  
- Docker Hub account (for image storage)

Region used: `us-east-1`

---

## How to Deploy Infrastructure
From your local machine:
```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
Terraform Output Example
ini
Copy code
alb_dns_name         = "devops-challenge-alb-1331013883.us-east-1.elb.amazonaws.com"
instance_public_ip   = "3.93.189.95"
instance_public_dns  = "ec2-3-93-189-95.compute-1.amazonaws.com"
Test the Application
Open the ALB URL in your browser:

bash
Copy code
http://devops-challenge-alb-1331013883.us-east-1.elb.amazonaws.com/info
Expected JSON output:

json
Copy code
{
  "instance_id": "i-01af92d0c65d0becc",
  "availability_zone": "us-east-1c",
  "timestamp": "2025-10-15T05:16:39.325193"
}
CI/CD Pipeline (GitHub Actions)
The GitHub Actions workflow in .github/workflows/deploy.yml automates application deployment whenever new code is pushed to the main branch.

Workflow Summary
Checks out the repository.

Builds the Docker image from the app directory.

Saves the Docker image and securely copies it to the EC2 instance.

SSHs into the EC2 instance, loads the image, and redeploys the container.

Verifies that the container is running successfully.

Required GitHub Secrets
Add the following secrets under your repository settings in Settings → Secrets → Actions:

Secret Name	Description	Example
AWS_ACCESS_KEY_ID	AWS access key (optional)	AKIA...
AWS_SECRET_ACCESS_KEY	AWS secret key (optional)	abc123...
EC2_PUBLIC_DNS	EC2 public DNS hostname	ec2-3-93-189-95.compute-1.amazonaws.com
EC2_SSH_KEY	Full contents of your .pem SSH key	-----BEGIN RSA PRIVATE KEY----- ...

Assumptions
Docker is pre-installed on EC2 through user_data.sh.

Security groups allow inbound HTTP traffic on port 80.

CI/CD deployment uses SSH with the appleboy GitHub Action.

IAM role has the least privilege permissions.

Terraform state is not included in the repository.

Future Improvements
Push Docker images to Amazon ECR instead of transferring manually.

Add ALB health checks and monitoring.

Implement blue-green or rolling deployments.

Integrate application-level logging with CloudWatch.

Automate infrastructure teardown using Terraform destroy.

Cleanup
When testing is complete, destroy AWS resources to avoid charges:

bash
Copy code
cd terraform
terraform destroy -auto-approve
Author
Aboubacar Koulibaly
DevSecOps & Cloud Security Engineer
Email: koulibalyaboubacar306@gmail.com
