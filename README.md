# Simple DevOps Learning Project: AWS Infrastructure with Terraform

A simple project for learning how to create a Java DevOps lab on AWS using Terraform. It provisions EC2 servers for Jenkins, a Jenkins agent, SonarQube, Nexus Repository, and Apache Tomcat.

This is a practice project. The repository provides infrastructure and installation scripts; you configure the tools and add your Java application pipeline after the servers are ready.

## What you will learn

- Create AWS EC2 instances and security groups with Terraform.
- Install DevOps tools using EC2 startup scripts.
- Use Jenkins and a build agent for automation.
- Explore code analysis with SonarQube and artifact storage with Nexus.
- Use Tomcat as a Java web application server.
- Remove the lab with Terraform when you finish.

## Lab overview

```text
Terraform
    |
    +-- Jenkins server       Pipeline controller
    +-- Jenkins agent        Machine for build jobs
    +-- SonarQube server     Code quality analysis
    +-- Nexus server         Build artifact storage
    +-- Tomcat server        Java web application hosting
```

A workflow you can build as a learning exercise is:

```text
Git repository -> Jenkins / agent -> Build and test
                                          |
                                  SonarQube analysis
                                          |
                                  WAR stored in Nexus
                                          |
                                  Deploy WAR to Tomcat
```

**The application source, Jenkins pipeline, agent connection, and integrations are not included in this repository.**

## Resources created

| Server | Instance type in `main.tf` | Web port |
| --- | --- | --- |
| Jenkins | `t3.micro` | `8080` |
| Jenkins agent | `t3.micro` | No agent web interface is configured |
| SonarQube | `t3.medium` | `9000` |
| Nexus | `t3.small` | `8081` |
| Tomcat | `t3.micro` | `8080` |

Terraform creates four security groups. The Jenkins controller and agent share one group. The default AWS region is `us-east-1`.

## Repository files

| File | Purpose |
| --- | --- |
| `provider.tf` | AWS provider configuration |
| `variables.tf` | Region, key-pair name, and an unused instance-type variable |
| `main.tf` | Five EC2 instances and their startup scripts |
| `security.tf` | SSH and tool web-access rules |
| `output.tf` | Jenkins, SonarQube, Nexus, and Tomcat URLs |
| `jenkins.sh` | Installs Java and Jenkins |
| `jenkins-slave.sh` | Installs a Java runtime on the intended build agent |
| `sonarqube.sh` | Starts SonarQube Community in Docker with named volumes |
| `nexes.sh` | Installs Nexus and configures its Java heap |
| `tomcat.sh` | Downloads and starts Tomcat 11 |

The Nexus script is named `nexes.sh` in this project, and `main.tf` references that exact filename.

## Before you start

You need an AWS account with permission to manage EC2 and security groups, Git, Terraform, AWS CLI, and an existing EC2 SSH key pair.

Review these settings before creating resources:

1. **AWS credentials:** `provider.tf` contains hardcoded credentials. Revoke/rotate exposed keys, remove them from the file, and authenticate through an AWS CLI profile or IAM role. Removing credentials from a file does not remove them from Git history. Use a provider configuration without embedded keys:

   ```hcl
   provider "aws" {
     region = var.aws_region
   }
   ```

2. **AMI and key pair:** Replace the hardcoded AMI in all five instance definitions with an appropriate Ubuntu x86_64 AMI for your region. The scripts use Ubuntu/Debian package commands. Set `us_key_pair` to a key pair that exists in that region.
3. **Networking:** The configuration assumes a default VPC and default subnet with public connectivity. It does not create a VPC or subnets. Restrict the current `0.0.0.0/0` inbound rules to your IP and the specific server-to-server access your lab needs.
4. **Instance sizes:** Sizes are hardcoded in `main.tf`; changing the `instance_type` variable currently has no effect. Adjust the resources directly if your builds or tools need more memory.
5. **Installation scripts:** Check the pinned Nexus and Tomcat downloads and the Jenkins package source before use. The SonarQube image uses the floating `community` tag. These examples may need updates as software changes.

## Getting started

### 1. Clone the repository

```bash
git clone https://github.com/prdps/DevOps-AWS-JAVA-Deployement-TF.git
cd DevOps-AWS-JAVA-Deployement-TF
```

Complete the configuration changes above and authenticate to AWS. Confirm the account you will use:

```bash
aws sts get-caller-identity
```

### 2. Create the lab

These commands create five billable EC2 instances and their associated resources. Review the plan before applying it.

```bash
terraform init
terraform validate
terraform plan -var="us_key_pair=YOUR_KEY_PAIR_NAME"
terraform apply -var="us_key_pair=YOUR_KEY_PAIR_NAME"
```

To change the region, also pass `-var="aws_region=YOUR_REGION"` to both plan and apply, and update the AMIs accordingly.

### 3. Open the tools

```bash
terraform output
```

Open the displayed URLs in your browser. Installation continues through EC2 user data after instance creation, so Terraform finishing does not mean every tool is ready.

For Jenkins, connect to its EC2 server and retrieve the initial setup password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Complete the setup wizard, install the plugins needed for your planned pipeline, and create your administrator account. Complete the initial setup for the other tools as well.

### 4. Connect the tools as a learning exercise

1. Install Git, a JDK, and your build tool, such as Maven, on the agent. The provided agent script installs only a Java runtime.
2. Add and connect the agent in Jenkins using your chosen launch method. Configure the required credentials and network access.
3. Add your Java application's Git repository and create a Jenkins pipeline to build and test it.
4. Configure SonarQube analysis and store the required token in Jenkins credentials.
5. Create an appropriate Nexus repository and configure your build to publish artifacts.
6. Configure a deployment method for Tomcat and deploy a WAR compatible with the installed Tomcat version.

Store passwords and tokens in the tools' credential stores rather than committing them to Git.

## Common problems and limitations

| Problem | What to check |
| --- | --- |
| Terraform reports an invalid AMI or missing key pair | Confirm both exist in the selected AWS region |
| Security group already exists | Check for another lab using the same fixed group names, such as `jenkins-sg` |
| Tool URL does not open | Allow time for installation; check the public IP, network rules, and service logs |
| Startup installation failed | Read `/var/log/cloud-init-output.log` on the affected server |
| Jenkins agent is offline | Register and launch the agent; installing Java alone does not connect it |
| Build fails or tool stops | Check JDK/build-tool installation, disk space, and memory usage |
| SonarQube fails to start | Inspect `sudo docker logs sonarqube` and address the reported host or memory requirements |
| Tools do not restart after reboot | Nexus and Tomcat are started directly; SonarQube has no container restart policy. Configure service management as a follow-up exercise |

The controller and agent currently have the same EC2 Name tag. Use their instance IDs to distinguish them, or give the agent a separate tag in `main.tf`.

## Clean up after learning

Save any application data or artifacts you want to keep, then run from the same Terraform working directory:

```bash
terraform destroy -var="us_key_pair=YOUR_KEY_PAIR_NAME"
```

Include the same region override if you used one during creation. Review the destruction plan and confirm that you are removing the intended lab.

Keep the Terraform state until cleanup is complete. Check the AWS console afterward for any remaining billable resources, especially anything you created manually. Data stored on these servers can be lost when the instances and their storage are removed.

---

Built for hands-on learning and experimentation with DevOps.
