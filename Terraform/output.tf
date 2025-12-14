output "master_public_ip" {
description = "Public IP of Jenkins master VM"
value = aws_instance.master.public_ip
}

output "Master_Jenkins_url" {
 description = "Jenkins URL on master EC2"
value = "http://${aws_instance.master.public_ip}:8080"
}

output "master_instance_id" {
value = aws_instance.master.id
}

#output "slave_instance_id" {
#value = aws_instance.slave.id
#}
#
#output "slave_instance_ip" {
#  description = "Public IP of slave VM"
#  value = aws_instance.slave.public_ip
#}

output "vpc_id" {
value = aws_vpc.main.id
}
