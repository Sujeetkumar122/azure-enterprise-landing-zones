<div align="center">

# 🏛️ Enterprise Azure Landing Zones (CAF Architecture)

[![Terraform](https://img.shields.io/badge/Terraform-v1.5%2B-844FBA?style=for-the-badge&logo=terraform&logoColor=white)](https://terraform.io)
[![Azure CAF](https://img.shields.io/badge/Architecture-Azure_CAF_Compliant-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](#)
[![CIS Benchmark](https://img.shields.io/badge/Compliance-CIS_Benchmark_v2.0-10B981?style=for-the-badge&logo=shield&logoColor=white)](#)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](#)

**Production-Grade Infrastructure as Code engineered with `for_each`, structured `map` types, and `dynamic` blocks for enterprise-scale multi-subscription environments.**

</div>

---

## 📌 Architectural Overview

This repository provides an enterprise-ready implementation of the **Microsoft Cloud Adoption Framework (CAF)** Azure Landing Zones. It enforces:

- 🛡️ **Zero-Trust Hub & Spoke Networking:** Centralized inspection via Azure Firewall NVA, User Defined Routes (UDR), and Private Link.
- ⚙️ **Modular Terraform Best Practices:** Zero hardcoded resources; 100% data-driven orchestration using `for_each` + `map(object)` schemas.
- 🔄 **Dynamic Block Optimization:** Seamless declaration of variable NSG security rules (`dynamic "security_rule"`) and route entries (`dynamic "route"`).
- 📜 **Shift-Left Security:** Automated CI/CD DevSecOps scanning via **TFLint**, **Checkov (CIS Azure Benchmark v2.0)**, and **Infracost**.

```mermaid
graph TD
    subgraph Hub["🛡️ Hub Network (Connectivity Subscription)"]
        FW["Azure Firewall NVA<br/>10.100.1.4"]
        GW["VPN / ExpressRoute Gateway"]
        HUB_VNET["Hub VNet Core<br/>10.100.0.0/16"]
        GW --- HUB_VNET
        HUB_VNET --- FW
    end

    subgraph Spokes["📦 Application Spokes"]
        APP_VNET["App Spoke VNet<br/>10.101.0.0/16"]
        DATA_VNET["Data Spoke VNet<br/>10.102.0.0/16"]
        HUB_VNET == "Peered (UDR 0.0.0.0/0)" ==> APP_VNET
        HUB_VNET == "Peered (UDR 0.0.0.0/0)" ==> DATA_VNET
    end

    classDef blue fill:#0B1F3A,stroke:#0078D4,stroke-width:2px,color:#fff;
    classDef green fill:#052e16,stroke:#10b981,stroke-width:2px,color:#fff;
    class Hub blue;
    class Spokes green;
```

---

## 🏗️ Module Structure

```
.
├── main.tf                 # Root orchestration with for_each and VNet peerings
├── variables.tf            # Strongly-typed map and object declarations
├── outputs.tf              # Resource IDs, IP allocations, and topology maps
├── terraform.tfvars.example# Production template values
├── azure-pipelines.yml     # Multi-stage CI/CD pipeline with Checkov & TFLint
└── modules/
    ├── vnet/               # Virtual Network & Subnet factory (for_each)
    ├── nsg/                # Security Groups with dynamic "security_rule"
    └── route_table/        # UDR Route Tables with dynamic "route"
```

---

## 🚀 Quickstart

### 1. Prerequisites
- Terraform `>= 1.5.0`
- Azure CLI `>= 2.50.0`
- Azure Subscription with `Owner` or `Contributor` + `User Access Administrator`

### 2. Deployment

```bash
# Clone the repository
git clone https://github.com/Sujeetkumar122/azure-enterprise-landing-zones.git
cd azure-enterprise-landing-zones

# Configure variables
cp terraform.tfvars.example terraform.tfvars

# Initialize & Validate
terraform init
terraform validate

# Plan and Inspect
terraform plan -out=tfplan

# Apply
terraform apply tfplan
```

---

## 🔒 Security & Compliance

All modules are audited against the **CIS Microsoft Azure Foundation Benchmark v2.0**:
- Default-deny inbound NSG rules enforced on all workload subnets.
- Mandatory forced-tunneling via central Azure Firewall (`0.0.0.0/0` UDR).
- No public IPs assigned to workload network interfaces.
- Remote state secured in geo-redundant storage with Customer-Managed Keys (CMK).

---

## 👤 Author

**Sujeet Kumar**  
*Senior DevSecOps Engineer & Enterprise Cloud Architect (17+ Years Experience)*  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://linkedin.com/in/sujeetkumar122)
[![GitHub](https://img.shields.io/badge/GitHub-Sujeetkumar122-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/Sujeetkumar122)
