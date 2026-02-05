locals {
  enable_custom_mail_from = var.custom_mail_from_subdomain == null ? false : true
}

data "aws_region" "current" {}

data "aws_route53_zone" "this" {
  name = var.domain_name
}

# SPF
resource "aws_route53_record" "this_spf_txt" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = data.aws_route53_zone.this.name
  type    = "TXT"
  ttl     = var.dns_record_spf.ttl
  records = ["v=spf1 include:amazonses.com -all"]
}


# SES DOMAIN IDENTITY
resource "aws_ses_domain_identity" "this" {
  domain = data.aws_route53_zone.this.name
}

resource "aws_route53_record" "this_amazonses_txt" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "_amazonses.${data.aws_route53_zone.this.name}"
  ttl     = 60
  type    = "TXT"

  records = [aws_ses_domain_identity.this.verification_token]
}

resource "aws_ses_domain_identity_verification" "this" {
  domain = aws_ses_domain_identity.this.id

  depends_on = [aws_route53_record.this_amazonses_txt]
}

# DKIM
resource "aws_ses_domain_dkim" "this" {
  domain = data.aws_route53_zone.this.name
}

resource "aws_route53_record" "this_amazonses_dkim_cname" {
  count = 3

  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${element(aws_ses_domain_dkim.this.dkim_tokens, count.index)}._domainkey.${data.aws_route53_zone.this.name}"
  ttl     = 3600
  type    = "CNAME"
  records = ["${element(aws_ses_domain_dkim.this.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

# DMARC
resource "aws_route53_record" "this_dmarc_txt" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "_dmarc.${data.aws_route53_zone.this.name}"
  type    = "TXT"
  ttl     = var.dns_record_dmarc.ttl
  records = var.dns_record_dmarc.records
}

# Custom MAIL FROM
resource "aws_ses_domain_mail_from" "this" {
  count = local.enable_custom_mail_from ? 1 : 0

  domain           = aws_ses_domain_identity.this.domain
  mail_from_domain = "${var.custom_mail_from_subdomain}.${aws_ses_domain_identity.this.domain}"
}

resource "aws_route53_record" "this_mail_from_mx" {
  count = local.enable_custom_mail_from ? 1 : 0

  zone_id = data.aws_route53_zone.this.zone_id
  name    = aws_ses_domain_mail_from.this[0].mail_from_domain
  type    = "MX"
  ttl     = "3600"
  records = ["10 feedback-smtp.${data.aws_region.current.region}.amazonses.com"]
}

resource "aws_route53_record" "this_mail_from_spf_txt" {
  count = local.enable_custom_mail_from ? 1 : 0

  zone_id = data.aws_route53_zone.this.zone_id
  name    = aws_ses_domain_mail_from.this[0].mail_from_domain
  type    = "TXT"
  ttl     = var.dns_record_custom_mail_from_spf.ttl
  records = var.dns_record_custom_mail_from_spf.records
}
