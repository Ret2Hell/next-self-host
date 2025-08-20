# DevOps Infrastructure Demo: Next.js Self-Hosted Application

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-623CE4?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-269539?style=for-the-badge&logo=nginx&logoColor=white)

## 🎯 Overview

This repository demonstrates comprehensive DevOps skills through the implementation of a complete Infrastructure as Code (IaC) pipeline for deploying a containerized Next.js application. The project showcases expertise in **Terraform**, **Ansible**, and **GitHub Actions** to create a fully automated deployment pipeline on Azure infrastructure.

> **Note**: This is a DevOps demonstration project focused on infrastructure automation and CI/CD practices rather than application development.

## 🛠️ Infrastructure Components

### **Terraform Infrastructure** 
- **Azure Virtual Machine**: Ubuntu 24.04 LTS with Standard_B2als_v2 instance
- **Networking**: VNet, subnet, public IP, and Network Security Groups
- **Security**: SSH access restricted to specific IP addresses
- **Load Balancing**: HTTP/HTTPS traffic configuration (ports 80/443)
- **Resource Management**: Organized Azure resource groups in France Central region

### **Ansible Configuration Management**
- **System Setup**: Automated installation of Docker, Docker Compose, Node.js, and Nginx
- **Application Deployment**: Git repository cloning and containerized application setup
- **Database Configuration**: PostgreSQL container with automated password generation
- **Security**: SSH key management and firewall configuration
- **Service Management**: Systemd service configuration for auto-startup

### **GitHub Actions CI/CD Pipeline**
- **Automated Deployment**: Triggered on push to main branch
- **Security Integration**: Dynamic Azure NSG rule management for runner IP access
- **SSH Management**: Secure connection handling with temporary access rules
- **Health Checks**: Application and container status verification
- **Rollback Capability**: Automated cleanup and error handling

## 📁 Project Structure

```
├── terraform/                 # Infrastructure as Code
│   ├── main.tf                # Azure resource definitions
│   ├── variables.tf           # Input variables
│   ├── outputs.tf             # Output values
│   └── terraform.tfvars       # Variable values
├── ansible/                   # Configuration Management
│   ├── deploy_app.yml         # Main deployment playbook
│   ├── configure_vm.yml       # VM configuration playbook
│   ├── inventory.ini          # Ansible inventory
│   └── templates/             # Configuration templates
│       ├── nginx.j2           # Nginx reverse proxy config
│       └── env.j2             # Environment variables template
├── .github/workflows/         # CI/CD Pipeline
│   └── deploy.yml             # GitHub Actions deployment workflow
├── docker-compose.yml         # Container orchestration
├── Dockerfile                 # Application containerization
└── update.sh                  # Deployment automation script
```

## 🔧 Deployment Process

### 1. **Infrastructure Provisioning**
```bash
cd terraform/
terraform init
terraform plan
terraform apply
```

### 2. **Server Configuration**
```bash
ansible-playbook -i ansible/inventory.ini ansible/configure_vm.yml
```

### 3. **Application Deployment**
```bash
ansible-playbook -i ansible/inventory.ini ansible/deploy_app.yml
```

### 4. **Automated CI/CD**
- Push changes to the main branch
- GitHub Actions automatically deploys to production
- Health checks verify successful deployment

### 5. **Infrastructure Teardown**
```bash
cd terraform/
terraform destroy
```
> **Warning**: This will permanently delete all Azure resources including the VM, storage, and network components. Ensure you have backed up any important data before running this command.

## 🔐 Required Secrets

The following secrets must be configured in GitHub repository settings:

```
AZURE_CLIENT_ID              # Azure Service Principal ID
AZURE_CLIENT_SECRET          # Azure Service Principal Secret
AZURE_TENANT_ID              # Azure Tenant ID
AZURE_SUBSCRIPTION_ID        # Azure Subscription ID
VM_SSH_PRIVATE_KEY           # SSH private key for VM access
VM_HOST                      # VM public IP address
VM_USER                      # VM username
```

## 🎯 Skills Demonstrated

### **Cloud Infrastructure (Azure)**
- Virtual machine provisioning and management
- Network configuration and security groups
- Resource group organization and management
- Public IP and load balancer configuration

### **Infrastructure as Code (Terraform)**
- HCL configuration syntax and best practices
- State management and workspace organization
- Resource dependencies and lifecycle management
- Variable interpolation and output management

### **Configuration Management (Ansible)**
- Playbook development and role organization
- Jinja2 templating for dynamic configurations
- Inventory management and host grouping
- Task idempotency and error handling

### **CI/CD (GitHub Actions)**
- Workflow automation and trigger configuration
- Secrets management and secure deployments
- Multi-step job orchestration
- Error handling and rollback procedures

### **Containerization (Docker)**
- Multi-stage Dockerfile optimization
- Docker Compose service orchestration
- Volume and network management
- Container security and resource limits

### **System Administration**
- Linux server configuration and management
- Service management with systemd
- Nginx reverse proxy configuration
- PostgreSQL database administration
