# Security Policy

## Status

Sky VPC is an engineering-beta Terraform network module. Repository CI validates configuration shape and scans infrastructure code, but there is no claim of a deployed, audited, compliant, or production-secure AWS environment.

## Security boundary

The module controls VPC/subnet routing and one web-tier security group. AWS account security, IAM, organization policies, SCPs, KMS, workload identity, host/container hardening, application authorization, TLS certificates, WAF, logging destinations, backup, incident response, and runtime monitoring are outside this repository.

## Defaults and operator responsibilities

- HTTP ingress is disabled by default.
- HTTPS ingress is configurable; narrow `web_ingress_cidrs` for non-public services.
- Private subnets do not auto-assign public addresses.
- Private outbound traffic uses same-AZ NAT gateways.
- State files may contain infrastructure metadata and must be stored in an appropriately protected backend when this module is deployed.
- Review Terraform plans before apply and use least-privilege deployment credentials.

## Reporting

Do not include credentials, Terraform state, AWS account identifiers, or other secrets in public vulnerability reports. Use the repository owner's private security-reporting channel where available.
