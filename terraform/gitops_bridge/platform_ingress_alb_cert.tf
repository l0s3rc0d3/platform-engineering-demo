# The following is needed to create the wildcard certificate to use it in the public load balancer
# Since we are on aws i choose to rely on aws services for this purpose (also cause my zone is hosted in aws + i bought the domain in aws)
# in other cloud providers (if they dont provide a service that manage certificates) or on premise i woudl rely completly on cert-manager 
# to automatically manage the ssl certifcates rotation
resource "aws_acm_certificate" "wildcard" {
  domain_name       = "*.${var.dns_public_zone}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.sdlc_env}-wildcard-cert"
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public.zone_id
}

resource "aws_acm_certificate_validation" "wildcard" {
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}