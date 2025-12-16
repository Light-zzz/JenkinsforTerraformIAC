output "Prometheus_public_ip" {
description = "Public IP of Jenkins master VM"
value = aws_instance.Prometheus.public_ip
}

output "Prometheus" {
 description = "Jenkins URL on master EC2"
value = "http://${aws_instance.Prometheus.public_ip}:9090"
}

output "Prometheus_instance_id" {
value = aws_instance.Prometheus.id
}

output "Grafana_instance_id" {
value = aws_instance.Grafana.id
}

output "Grafana" {
 description = "Jenkins URL on master EC2"
value = "http://${aws_instance.Grafana.public_ip}:3000"
}

output "Grafana_instance_ip" {
 description = "Public IP of slave VM"
 value = aws_instance.Grafana.public_ip
}

output "Nginx" {
    description = "Nginx URL"
    value = "http://${aws_instance.Nginx-Server.public_ip}:8080"
}

output "Nginx-IP" {
    description = "Nginx Public IP"
  value = aws_instance.Nginx-Server.public_ip
}

output "vpc_id" {
value = aws_vpc.main.id
}
