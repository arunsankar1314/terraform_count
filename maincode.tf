resource "aws_instance" "web2" {

  count                  = 3
  ami                    = var.ami
  instance_type          = var.type
  key_name               = aws_key_pair.mykey.key_name
  user_data              = file("setup.sh")
  vpc_security_group_ids = [aws_security_group.secgroup1.id]
  tags = {
    Name = "${var.Name}-${var.Env}"
  }
}

resource "aws_key_pair" "mykey" {
  key_name   = var.Name
  public_key = file("count.pub")
}

resource "aws_security_group" "secgroup1" {
  name_prefix = "instance_sg2"
  tags = {
    name = "${var.Name}-${var.Env}"
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
    #    security_group_id = [aws_security_group.secgroup1.id]
  }

}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.secgroup1.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.secgroup1.id
}
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.secgroup1.id
}

#resource "aws_route53_record" "www" {
#  zone_id = var.hosted_zone_id
#  name    = var.domain_name
#  type    = "A"
#  ttl     = 300
#  records = [aws_instance.web2[count.index].public_ip]
#}
