resource "aws_route53_zone" "foryou_rtz" {
  name          = var.route53
  force_destroy = true
}

resource "aws_route53_record" "domain" {
  zone_id = aws_route53_zone.foryou_rtz.id
  name    = var.route53
  type    = var.route_type

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.foryou_rtz.id
  name    = var.route53_www
  type    = var.route_type

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

