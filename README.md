A production-ready URL shortener service deployed on AWS ECS Fargate. Takes long URLs and spits out short codes that redirect back to the original.

## What This Does

Send a long URL:
```bash
POST /shorten
{
  "url": "https://example.com/some/really/long/path"
}
```

Get back a short code:
```json
{
  "short": "abc123",
  "url": "https://example.com/some/really/long/path"
}
```

Visit the short URL and get redirected:
```bash
GET /abc123
→ 302 redirect to https://example.com/some/really/long/path
```

## Architecture

The app runs on ECS Fargate in private subnets (no public IPs). An Application Load Balancer handles incoming traffic, AWS WAF filters out malicious requests, and DynamoDB stores the URL mappings.

**Key Design Decisions:**

- **No NAT Gateway**: Uses VPC endpoints for ECR, DynamoDB, S3, and CloudWatch Logs instead. Saves about $30/month.
- **Blue/Green Deployments**: CodeDeploy handles zero-downtime releases with automatic rollback if health checks fail.
- **Private Subnets Only**: ECS tasks have no direct internet access. Everything goes through VPC endpoints or the ALB.
- **HTTPS**: ACM certificate with automatic DNS validation through Route53.

### Infrastructure Components

- **ECS Fargate**: Runs the containerized Python app (FastAPI)
- **Application Load Balancer**: Public-facing endpoint with HTTPS
- **AWS WAF**: Protects against common web exploits (SQL injection, XSS, bad bots)
- **DynamoDB**: Stores short code → URL mappings (PAY_PER_REQUEST mode)
- **VPC Endpoints**: Interface endpoints for ECR/CloudWatch, Gateway endpoints for S3/DynamoDB
- **CodeDeploy**: Manages blue/green deployments
- **CloudWatch**: Logs, metrics, alarms, and dashboard

## Project Structure
```
.
├── app/                    # FastAPI application
│   ├── main.py
│   ├── requirements.txt
│   └── Dockerfile
├── infra/                  # Terraform infrastructure
│   ├── modules/
│   │   ├── vpc/
│   │   ├── ecs/
│   │   ├── alb/
│   │   ├── dynamodb/
│   │   ├── waf/
│   │   ├── endpoints/
│   │   └── ...
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── .github/
    └── workflows/
        └── deploy.yml      # CI/CD pipeline
```

## Prerequisites

- AWS Account
- Terraform >= 1.0
- Docker
- AWS CLI configured
- Route53 hosted zone (for custom domain)

## Deployment

### 1. Set Up Remote State Backend

First, create the S3 bucket and DynamoDB table for Terraform state:
```bash
cd infra
# Edit backend.tf with your bucket name
terraform init
```

### 2. Configure Variables

Create a `terraform.tfvars` file:
```hcl
domain_name = "your-domain.com"
alert_email = "your-email@example.com"
```

### 3. Deploy Infrastructure
```bash
terraform plan
terraform apply
```

This creates everything: VPC, subnets, ECS cluster, ALB, DynamoDB table, WAF rules, etc.

### 4. GitHub Actions Setup

The CI/CD pipeline uses OIDC to authenticate with AWS (no hardcoded keys).

Add these secrets to your GitHub repo:
- `AWS_ACCOUNT_ID`
- `AWS_REGION`

The workflow:
1. Builds and scans the Docker image
2. Pushes to ECR
3. Updates ECS task definition
4. Triggers CodeDeploy blue/green deployment

## Monitoring

CloudWatch dashboard includes:
- ALB request count and 5xx errors
- Response time percentiles (p50, p95, p99)
- ECS CPU and memory utilization
- DynamoDB throttled requests
- Target health status

Alarms set up for:
- ECS CPU > 80%
- ECS Memory > 80%
- DynamoDB throttling

Notifications go to the configured email via SNS.

## Cost Breakdown

Approximate monthly costs (assuming minimal traffic):

| Service | Est. Cost |
|---------|-----------|
| ALB | ~$16 |
| ECS Fargate (2 tasks, 1GB RAM, 0.5 vCPU) | ~$15 |
| VPC Endpoints (3 interface) | ~$21 |
| DynamoDB (on-demand, minimal use) | ~$1 |
| WAF | ~$5 |
| Route53 hosted zone | $0.50 |
| **Total** | **~$58/month** |

**Cost savings**: Avoiding NAT Gateway saves ~$32/month. The trade-off is paying for VPC endpoints, but overall it's cheaper for low-to-medium traffic.

## Security Features

- **WAF Rules**:
  - AWS Managed Core Rule Set
  - Known Bad Inputs protection
  - SQL injection protection
  - IP reputation filtering

- **IAM Least Privilege**:
  - Task role: DynamoDB GetItem/PutItem only
  - Execution role: ECR pull and CloudWatch Logs write only

- **Network Isolation**:
  - ECS tasks in private subnets
  - Security groups restrict traffic (ALB → ECS only)
  - No public IPs on tasks

## Trade-offs & Decisions

**Why ECS over Lambda?**
Lambda would've been simpler, but I wanted to practice container orchestration and blue/green deployments. For a real URL shortener with sustained traffic, Fargate also avoids cold start latency.

**Why Blue/Green over Canary?**
Simpler to implement. Production systems would benefit from gradual traffic shifting, but for a portfolio project, blue/green demonstrates the concept well enough.

**Why Interface Endpoints?**
More expensive than NAT Gateway for high data transfer, but for a low-traffic demo app, the predictable pricing is worth it. Also shows I'm thinking about cost optimization.

**Task Resources (1GB/1vCPU)**
Probably overkill for a simple URL shortener, but leaves room for adding features like analytics or bulk operations without redeploying.

## What I'd Add Next

- **Analytics**: Track click counts per shortened URL
- **TTL**: Auto-expire old links using DynamoDB TTL
- **Rate Limiting**: API Gateway with usage plans or WAF rate-based rules
- **CloudFront**: Cache redirects at edge locations
- **Custom Short Codes**: Let users specify their own short codes
- **Bulk Shortening**: Endpoint to shorten multiple URLs at once

## Cleanup

To avoid ongoing AWS charges:
```bash
cd infra
terraform destroy -auto-approve
```

This tears down everything except the S3 state bucket (manual deletion required for safety).

## Lessons Learned

- VPC endpoints are finicky. Make sure your security groups allow HTTPS (443) from ECS tasks.
- CodeDeploy needs both target groups created upfront, even though only one is active initially.
- DynamoDB PAY_PER_REQUEST is great for demos but watch out for unpredictable costs in production.
- GitHub OIDC trust policies need exact repo names - wildcards don't work the way you'd expect.

---