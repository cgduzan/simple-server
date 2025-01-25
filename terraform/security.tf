resource "aws_security_group" "allow_dev_app" {
  name        = "allow_dev_app_sg"
  description = "Allow inbound traffic on 3000 and all outbound traffic"
  # Using the default VPC, so no need to specify the VPC ID
  # vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_dev_app_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_3000_ipv4" {
  security_group_id = aws_security_group.allow_dev_app.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

resource "aws_vpc_security_group_ingress_rule" "allow_3000_ipv6" {
  security_group_id = aws_security_group.allow_dev_app.id
  cidr_ipv6         = "::/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_dev_app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_dev_app.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}