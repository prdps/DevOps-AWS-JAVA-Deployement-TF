# Jenkins
resource "aws_instance" "DevOps-Project1-Jenkins" {
  ami           = "ami-0ec10929233384c7f"
  instance_type = "t3.micro"
  key_name      = var.us_key_pair
  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = file("jenkins.sh")

  tags = { Name = "DevOps-Project1-Jenkins" }
}

# SonarQube
resource "aws_instance" "DevOps-Project1-SonarQube" {
  ami           = "ami-0ec10929233384c7f"
  instance_type = "t3.small"
  key_name      = var.us_key_pair
  security_groups = [aws_security_group.sonarqube_sg.name]

  user_data = file("sonarqube.sh")

  tags = { Name = "DevOps-Project1-SonarQube" }
}

# Nexus
resource "aws_instance" "DevOps-Project1-Nexus" {
  ami           = "ami-0ec10929233384c7f"
  instance_type = "t3.micro"
  key_name      = var.us_key_pair
  security_groups = [aws_security_group.nexus_sg.name]

  user_data = file("nexes.sh")

  tags = { Name = "DevOps-Project1-Nexus" }
}

# Tomcat
resource "aws_instance" "DevOps-Project1-Tomcat" {
  ami           = "ami-0ec10929233384c7f"
  instance_type = "t3.micro"
  key_name      = var.us_key_pair
  security_groups = [aws_security_group.tomcat_sg.name]

  user_data = file("tomcat.sh")

  tags = { Name = "DevOps-Project1-Tomcat" }
}