variable "domain_name" {
  description = "Domain to setup SES for"
  type        = string
}

variable "dns_record_spf" {
  description = "SPF TXT record options"
  type = object({
    ttl     = optional(number, 3600)
    records = optional(list(string), ["v=spf1 include:amazonses.com ~all"])
  })
  default = {}
}

variable "dns_record_dmarc" {
  description = "DMARC TXT record options"
  type = object({
    ttl     = optional(number, 3600)
    records = optional(list(string), ["v=DMARC1; p=none"])
  })
  default = {}
}

variable "dns_record_custom_mail_from_spf" {
  description = "CUSTOM MAIL FROM SPF TXT record options"
  type = object({
    ttl     = optional(number, 3600)
    records = optional(list(string), ["v=spf1 include:amazonses.com -all"])
  })
  default = {}
}

variable "custom_mail_from_subdomain" {
  description = "Custom MAIL FROM subdomain for full DMARC complience\n\n"
  type        = string
  default     = null
}
