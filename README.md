# Terraform Project for oiai

This Terraform project manages the infrastructure and deployments for the `oiai` environment. It is organized into three main directories that handle different aspects of the infrastructure, with custom modules provided for reusable components.


- You can try argocd here -> https://argocd.oiai.thisguydeploys.com
- You can try grafana here -> https://grafana.oiai.thisguydeploys.com

Credentials will be shared throug email.

## Project Structure

``` bash
.
├── 01-Oiai-Dev         # Cloud infrastructure (VPC, EKS, etc.)
│   ├── backend.tf      # tf backend configuration to save the state, in this s3
│   ├── ecr.tf          # ecr repositoies implementation to save docker images
│   ├── eks.tf          # EKS cluster, using node groups and addons.
│   ├── iam.tf          # IAM roles, in this case the IAM role used for OIDC
│   ├── locals.tf       # locals variables
│   ├── outputs.tf      # outputs to be consumed in other folders (vpc, eks, ecr)
│   ├── providers.tf    # providers for aws and kubernete
│   └── vpc.tf          # vpc implementation with public and private subnets
├── 02-Oiai-Dev         # Kubernetes non-functional infrastructure (metrics, monitoring, GitOps tools)
│   ├── argocd.tf       # argocd installation, with s3 plugin installation (see modules/argocd/values-argocd.yml) also, argo cd image updater (with ecr login in the parameters)
│   ├── aws-load-balancer-controller.tf # Controller to handle ALB integration with ingress and services.
│   ├── backend.tf      # tf backend configuration to save the state, in this s3
│   ├── ebs.tf          # ebs csi helm chart implementation
│   ├── grafana.tf      # grafana installation
│   ├── locals.tf       # locals variables
│   ├── metrics-server.tf   # metrics serverm, installed to feed HPA
│   ├── namespaces.tf   # namespaces creation
│   ├── prometheus-operator.tf  # prometheus installation
│   ├── providers.tf    # providers including aws, kubernetes and grafana.
│   └── remote-state.tf # state able to get folder 01 outputs, and transform it in locals.
├── 03-Oiai-Dev          # Functional infrastructure (applications, databases, secrets, etc.)
│   ├── api-db.tf       # rds postgres implementation
│   ├── api.tf          # argocd application implementation, referencing oiai-api-dev-chart
│   ├── backend.tf      # tf backend configuration to save the state, in this s3
│   ├── locals.tf       # locals variables
│   ├── providers.tf    # providers including aws and kubernetes
│   ├── remote-state.tf # state able to get folder 01 outputs, and transform it in locals.
│   └── web.tf          # s3 web implementation for frontend application.
└── modules              # Custom Terraform modules
    ├── argocd
    │   ├── main.tf
    │   ├── values-argo-cd.yaml
    │   └── variables.tf
    ├── aws-load-balancer-controller
    │   ├── main.tf
    │   └── variables.tf
    ├── ecr_repo
    │   ├── locals.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── grafana
    │   ├── grafana-dashboards              # grafana dashboard, but only eks metrics is working right now
    │   │   ├── multi-accounts-alb.json
    │   │   ├── multi-accounts-clb.json
    │   │   ├── multi-accounts-nlb.json
    │   │   ├── multi-accounts-rds-metrics.json
    │   │   ├── multi-cluster-eks-logs.json
    │   │   └── multi-cluster-eks-metrics.json
    │   ├── main.tf
    │   ├── providers.tf
    │   ├── values.yaml
    │   └── variables.tf
    ├── prometheus-operator
        ├── main.tf
        ├── values-prometheus.yaml
        └── variables.tf
```

## Directory Breakdown

- **01-Oiai-Dev**: Used for non-functional cloud infrastructure, such as VPCs, EKS clusters, and related resources.
- **02-Oiai-Dev**: Contains non-functional infrastructure within Kubernetes, such as monitoring tools (Grafana, Prometheus), GitOps tools (ArgoCD), and controllers.
- **03-Oiai-Dev**: Manages functional infrastructure including applications, databases, secrets, and all dependencies necessary for the applications to run.

## Modules

The `modules` directory contains custom modules created for this project, designed to be reusable across the different directories. Most of the Terraform modules used, however, come from the Terraform Registry, such as the VPC module.


## How ArgoCD Image Updater Works

The **ArgoCD Image Updater** automates the process of deploying new images to the Kubernetes cluster by tracking changes in the image registry and triggering updates when a new image version is available.

1. **oiai-backend** repository pushes a new commit to the `main` branch.
2. This triggers a GitHub Action that builds a new Docker image and pushes it to the ECR repository.
3. **ArgoCD Image Updater** detects the new image in ECR and automatically creates a commit in the `oiai-api-dev-chart` repository.
4. ArgoCD, configured with GitOps, notices the new commit and deploys the updated image to the Kubernetes cluster.

![Image Placeholder](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*GSfyL9C5Pksz6iViFnNsIg.png)

This flow ensures continuous delivery and integration, keeping the application up-to-date with the latest changes.

## Decisions

 I decided to use official modules from the marketplace because they save a lot of time when implementing infrastructure.
- I chose to use 3 availability zones, placing 2 subnets in each: one public and one private.
- I used nodegroups and autoscaling groups to provision nodes to the EKS cluster because, for a small project, nodegroups were sufficient.
- I opted for this folder structure in Terraform because it speeds up execution time and separates functional from non-functional infrastructure, reducing the risk of outages.
- I selected Grafana as the observability tool because it integrates well with the most commonly used Kubernetes data sources like Prometheus and Loki.
- I chose ArgoCD as the CD tool because it allows for a fast implementation of continuous delivery solutions and provides visibility tools for synchronization processes.
- I used the metrics-server and HPA to handle pod autoscaling for the API, as it is a simple and effective solution for this use case.
- I decided to follow the principle of least privilege to maintain security in the application; nodes and databases are isolated in private networks and protected by firewalls. However, in the future, I would increase security by using SecurityGroup CRDs to use it as the only entry point to the firewall, instead of relying on CIDRs, which could be risky.

## Potential Improvements

With more time, several enhancements could be made to this Terraform project:

- **Cluster Autoscaling with Karpenter**: Implementing Karpenter for efficient and cost-effective Kubernetes cluster autoscaling.
- **Log Management with Loki**: Integrating Loki for centralized log management, allowing consumption of logs in Grafana.
- **Distributed Tracing with Tempo**: Using Tempo for distributed tracing and visualizing it in Grafana.
- **Advanced Monitoring Dashboards**: Creating more dashboards to cover various aspects of application and infrastructure monitoring.
- **High Availability with Aurora**: Migrating to Aurora instead of using a standard RDS instance to ensure higher availability, though this was avoided to keep costs low in my personal account.
- **S3/CloudFront Stack for Deployment**: Utilizing an S3/CloudFront stack for optimal content delivery; however, due to a service quota limitation, creating a CloudFront distribution was not possible at this time.
- **Security Tools**:In the future, I would like to implement code quality monitoring tools, such as SonarQube, and security tools like Splunk and Kyverno for Kubernetes policy management.
-  **Terraform Testing**I also would have liked to implement Terraform tests; however, I did not have sufficient time. I would focus on testing critical components to avoid potential outages caused by a `terraform apply`.

## Future Work

These enhancements would provide better scalability, monitoring, and performance for the infrastructure:

- **Add Karpenter for Autoscaling**: Automate cluster scaling based on real-time workload demands.
- **Enhance Logging and Tracing**: Integrate Loki and Tempo for improved observability.
- **Optimize Storage with Aurora**: Switch to Aurora for greater availability and resilience.
- **Resolve CloudFront Limitations**: Address the AWS service quota to enable the use of CloudFront for improved content delivery.

This project demonstrates a flexible and modular approach to infrastructure management using Terraform, making it easier to manage and extend as requirements evolve.
