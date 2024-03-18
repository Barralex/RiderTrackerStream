resource "aws_instance" "express_realtime_server" {
  ami                    = "ami-0d7a109bf30624c99"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_web.id]

  user_data = <<-EOF
      #!/bin/bash
      curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
      sudo yum install -y nodejs
      sudo yum install -y git
      mkdir /home/ec2-user/app
      cd /home/ec2-user/app
      git clone https://github.com/Barralex/riders-real-time.git .
      npm install
      sudo node index.js
    EOF

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_traffic"
  }
}


resource "aws_eip" "ip" {
  instance = aws_instance.express_realtime_server.id
}
