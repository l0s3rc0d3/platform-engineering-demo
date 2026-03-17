resource "aws_security_group" "alb_shared" {
  name        = "${var.eks_name}-public-alb-sg"
  description = "Security group for the shared public ALB"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description = "HTTP from whitelisted IPs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_whitelist
  }

  ingress {
    description = "HTTPS from whitelisted IPs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.alb_whitelist
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.eks_name}-public-alb-sg"
    IngressTier = "PublicALB"
  }
}