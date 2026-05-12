output "jenkins_url" {
  value = "http://${aws_instance.DevOps-Project1-Jenkins.public_ip}:8080"
}

output "sonarqube_url" {
  value = "http://${aws_instance.DevOps-Project1-SonarQube.public_ip}:9000"
}

output "nexus_url" {
  value = "http://${aws_instance.DevOps-Project1-Nexus.public_ip}:8081"
}

output "tomcat_url" {
  value = "http://${aws_instance.DevOps-Project1-Tomcat.public_ip}:8080"
}