# johnuja-aws-infra-proj

A foundational Terraform project for provisioning a secure, cost-effective, and professional AWS infrastructure. This project demonstrates Infrastructure as Code (IaC) best practices using a GitOps workflow with Terraform Cloud.

## Project Overview

This repository contains the Terraform code to build a foundational network and storage infrastructure in AWS. It is designed to be a reusable and easily understandable starting point for more complex applications. The entire lifecycle of the infrastructure is managed through a CI/CD pipeline orchestrated by Terraform Cloud, triggered by commits to this GitHub repository.

## Architecture Diagram

The following diagram illustrates the provisioned resources and the CI/CD workflow:

```mermaid
graph TD;
    subgraph "CI/CD Workflow"
        A[GitHub Repository<br/>main.tf, variables.tf] -- "Git Push" --> B{Terraform Cloud};
    end

    subgraph "Managed AWS Infrastructure"
        VPC[<font size=5><b>VPC</b></font><br/>10.0.0.0/16];
        IGW[Internet Gateway];
        
        subgraph "Public Subnet"
            direction LR
            PubRT[Route Table]
        end

        subgraph "Private Subnet"
            direction LR
            PrivRT[Route Table]
        end

        S3[S3 Bucket];
        SG[Security Group];

        VPC --> IGW;
        VPC -- contains --> PubRT;
        VPC -- contains --> PrivRT;
        VPC -- contains --> SG;
        PubRT -- "0.0.0.0/0" --> IGW;
    end

    B -- "Plan & Apply" --> VPC;
    B -- "Manages State" --> S3;

    style VPC fill:#FF9900,stroke:#333,stroke-width:2px
    style S3 fill:#569A31,stroke:#333,stroke-width:2px
    style IGW fill:#FF9900,stroke:#333,stroke-width:2px
    style SG fill:#FF9900,stroke:#333,stroke-width:2px
```

## Live Pipeline Verification

The following images from the Terraform Cloud workspace serve as proof that the infrastructure described above was successfully deployed and is being actively managed through the CI/CD pipeline.

### Successful Plan & Apply

*This screenshot shows the successful completion of a run triggered by a `git push` to the `main` branch, demonstrating a working GitOps pipeline.*

**(run.png)**
<img width="1439" alt="Screenshot 2025-06-21 at 8 27 30 PM" src="https://github.com/user-attachments/assets/2d6fbe48-924a-41c6-abcd-7aed74211ea8" />


### Managed Resources

*This screenshot lists the 13 infrastructure resources being managed by Terraform Cloud, confirming its control over the live AWS environment.*

**(Resources.png)**
<img width="1440" alt="Screenshot 2025-06-21 at 8 13 53 PM" src="https://github.com/user-attachments/assets/50b3b348-8c28-438e-b745-499b571091bc" />

## Core Infrastructure Components

-   **VPC:** A logically isolated virtual network (`10.0.0.0/16`) to house all resources.
-   **Subnets:**
    -   A **Public Subnet** with a route to the Internet Gateway, suitable for public-facing resources like load balancers.
    -   A **Private Subnet** with no direct internet access, suitable for backend services and databases.
-   **Internet Gateway:** Provides the VPC with access to the internet.
-   **Route Tables:** Control the flow of traffic within the VPC.
-   **S3 Bucket:** A private S3 bucket for general-purpose object storage.
-   **Security Group:** A basic outbound security group allowing all egress traffic.

## How It Works

1.  **Code:** All infrastructure is defined in `.tf` files in this repository.
2.  **Commit & Push:** Any change to the Terraform code is committed and pushed to the `main` branch on GitHub.
3.  **Trigger:** A webhook notifies Terraform Cloud of the new commit.
4.  **Plan:** Terraform Cloud automatically runs a `terraform plan` to determine the necessary changes.
5.  **Apply:** After manual approval in the Terraform Cloud UI, the changes are applied to the AWS account.

## Next Steps

This foundational project is now complete. You can view the live, managed state of this infrastructure in your Terraform Cloud workspace. From here, you could:

-   Add EC2 instances, RDS databases, or load balancers that use this network foundation.
-   Create a new branch in this repository to experiment with changes, seeing the proposed plan in Terraform Cloud before merging.
-   Showcase this repository and your Terraform Cloud workspace to demonstrate your cloud and DevOps skills. 
