output "instance_public_ip" {
  value       = aws_instance.app.public_ip
  description = "Public IP of the Flask EC2 instance"
}

output "alb_dns_name" {
  value       = aws_lb.app_alb.dns_name
  description = "DNS name of the Application Load Balancer"
}
