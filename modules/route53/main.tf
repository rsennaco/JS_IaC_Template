# Route 53 Zone config
resource "aws_route53_zone" "node_zone" {
    name = var.URL
}

# Route 53 Record config
resource "aws_route53_record" "node_record" {
    zone_id = aws_route53_zone.node_zone.zone_id
    name = "node-app"
    type = "A"
    alias {
        name = aws_lb.node_lb.dns_name
        zone_id = aws_lb.node_lb.zone_id
        evaluate_target_health = true
    }
}