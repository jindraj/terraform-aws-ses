# Terraform module for AWS SES

This module will setup AWS SES resources:
- SES domain identity
- SPF record
- DKIM records
- DMARC record
- optionaly custom MAIL FROM domain

## Usage

```terraform
module "ses" {
  source  = "cookielab/ses/aws"
  version = "~> 0.0"

  domain_name                = "example.com"
  custom_mail_from_subdomain = "mail"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.this_amazonses_dkim_cname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.this_amazonses_txt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.this_dmarc_txt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.this_mail_from_mx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.this_mail_from_spf_txt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.this_spf_txt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_ses_domain_dkim.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim) | resource |
| [aws_ses_domain_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity) | resource |
| [aws_ses_domain_identity_verification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity_verification) | resource |
| [aws_ses_domain_mail_from.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_mail_from) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_mail_from_subdomain"></a> [custom\_mail\_from\_subdomain](#input\_custom\_mail\_from\_subdomain) | Custom MAIL FROM subdomain for full DMARC complience | `string` | `null` | no |
| <a name="input_dns_record_custom_mail_from_spf"></a> [dns\_record\_custom\_mail\_from\_spf](#input\_dns\_record\_custom\_mail\_from\_spf) | CUSTOM MAIL FROM SPF TXT record options | <pre>object({<br/>    ttl     = optional(number, 3600)<br/>    records = optional(list(string), ["v=spf1 include:amazonses.com -all"])<br/>  })</pre> | `{}` | no |
| <a name="input_dns_record_dmarc"></a> [dns\_record\_dmarc](#input\_dns\_record\_dmarc) | DMARC TXT record options | <pre>object({<br/>    ttl     = optional(number, 3600)<br/>    records = optional(list(string), ["v=DMARC1; p=none"])<br/>  })</pre> | `{}` | no |
| <a name="input_dns_record_spf"></a> [dns\_record\_spf](#input\_dns\_record\_spf) | SPF TXT record options | <pre>object({<br/>    ttl     = optional(number, 3600)<br/>    records = optional(list(string), ["v=spf1 include:amazonses.com ~all"])<br/>  })</pre> | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain to setup SES for | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
