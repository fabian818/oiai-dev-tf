# Terraform Project for oiai

This Terraform project manages the infrastructure and deployments for the `oiai` environment. It is organized into three main directories that handle different aspects of the infrastructure, with custom modules provided for reusable components.

## Project Structure

<<<
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
>>>

## Directory Breakdown

- **01-Oiai-Dev**: Used for non-functional cloud infrastructure, such as VPCs, EKS clusters, and related resources.
- **02-Oiai-Dev**: Contains non-functional infrastructure within Kubernetes, such as monitoring tools (Grafana, Prometheus), GitOps tools (ArgoCD), and controllers.
- **03-Oiai-Dev**: Manages functional infrastructure including applications, databases, secrets, and all dependencies necessary for the applications to run.

## Modules

The `modules` directory contains custom modules created for this project, designed to be reusable across the different directories. Most of the Terraform modules used, however, come from the Terraform Registry, such as the VPC module.

## Potential Improvements

With more time, several enhancements could be made to this Terraform project:

- **Cluster Autoscaling with Karpenter**: Implementing Karpenter for efficient and cost-effective Kubernetes cluster autoscaling.
- **Log Management with Loki**: Integrating Loki for centralized log management, allowing consumption of logs in Grafana.
- **Distributed Tracing with Tempo**: Using Tempo for distributed tracing and visualizing it in Grafana.
- **Advanced Monitoring Dashboards**: Creating more dashboards to cover various aspects of application and infrastructure monitoring.
- **High Availability with Aurora**: Migrating to Aurora instead of using a standard RDS instance to ensure higher availability, though this was avoided to keep costs low in my personal account.
- **S3/CloudFront Stack for Deployment**: Utilizing an S3/CloudFront stack for optimal content delivery; however, due to a service quota limitation, creating a CloudFront distribution was not possible at this time.

## Future Work

These enhancements would provide better scalability, monitoring, and performance for the infrastructure:

- **Add Karpenter for Autoscaling**: Automate cluster scaling based on real-time workload demands.
- **Enhance Logging and Tracing**: Integrate Loki and Tempo for improved observability.
- **Optimize Storage with Aurora**: Switch to Aurora for greater availability and resilience.
- **Resolve CloudFront Limitations**: Address the AWS service quota to enable the use of CloudFront for improved content delivery.

This project demonstrates a flexible and modular approach to infrastructure management using Terraform, making it easier to manage and extend as requirements evolve.
