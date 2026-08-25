# Sky VPC Terraform Module

**Status: engineering beta.** This repository defines a focused AWS VPC network baseline with Terraform. It is not evidence that any AWS environment has been deployed.

## What it creates

- One VPC with DNS support and hostnames enabled.
- One public and one private subnet per configured Availability Zone.
- An Internet Gateway and shared public route table.
- One NAT Gateway and private route table per Availability Zone, with each private subnet routed through the NAT Gateway in the same zone.
- A web-tier security group with HTTPS ingress and optional HTTP ingress.
- Consistent project/environment Terraform tags.

## Safety defaults

HTTP ingress is disabled by default. HTTPS ingress defaults to `0.0.0.0/0` for a public web-tier use case; production consumers should narrow `web_ingress_cidrs` whenever possible. Private subnets do not assign public IPv4 addresses. Terraform variables validate region shape, project names, environment values, CIDRs, and Availability Zone cardinality.

## Verify locally

```bash
terraform fmt -check -recursive
terraform init -backend=false -input=false
terraform validate
terraform providers lock -platform=linux_amd64
```

GitHub Actions also runs a HIGH/CRITICAL infrastructure configuration scan. CI validation does not contact AWS and does not prove IAM permissions, quotas, route behavior in a live account, cost controls, or deployment success.

## Example

```hcl
module "network" {
  source = "./"

  region             = "us-east-1"
  project_name       = "skycoin4444"
  environment        = "staging"
  vpc_cidr           = "10.44.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  web_ingress_cidrs  = ["203.0.113.0/24"]
  enable_http_ingress = false
}
```

## Architecture boundary

This module intentionally stops at the network foundation. It does not create EKS/ECS/EC2 workloads, databases, load balancers, WAF, Route 53, ACM certificates, Transit Gateway, VPC endpoints, flow-log storage, VPN/Direct Connect, or centralized egress. Those should be separate composable modules with their own evidence and security boundaries.

The default design uses one NAT Gateway per Availability Zone to avoid routing private-subnet egress through another zone. NAT Gateways incur AWS charges; consumers should evaluate the cost/availability tradeoff for their environment.

## SKYCOIN4444 integration

The outputs expose VPC, subnet, route-table, NAT Gateway, and web security-group identifiers so independently deployed SKYCOIN4444 services can consume the network through Terraform module composition instead of copied infrastructure definitions.

See `SECURITY.md` for deployment assumptions and limitations.
