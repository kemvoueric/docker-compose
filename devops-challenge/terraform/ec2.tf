resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
    subnet_id                   = var.subnet_id
  }

  block_device_mappings {
    device_name = "/dev/xvda"
  
    ebs {
      volume_size           = var.ebs_volume_size
      volume_type           = var.ebs_volume_type
      delete_on_termination = true
      encrypted             = var.ebs_encrypted
    }
  }

  user_data = filebase64("${path.module}/user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-ec2"
      Environment = var.environment
    }
  }
}

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  key_name               = var.key_pair_name
  user_data              = file("${path.module}/user_data.sh")

  tags = {
    Name        = "${var.project_name}-ec2"
    Environment = var.environment
  }

  depends_on = [aws_iam_instance_profile.ec2_instance_profile]
}

