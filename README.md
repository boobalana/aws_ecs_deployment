# aws_ecs_deployment
aws_ecs_deployment with terraform

This Repository is set of terraform modules to create ECS Cluster.


Here we have modules for all services which are needed for ECS Cluser.

List of Modules.
1) ecs - for Creating ECS cluster, Service and task-definition
2) iam - Used for creating IAM Roles for services to connect with other service.
3) loadbalancer - Used for Creating Application loadbalancer (ALB).
4) networking - This Modules create a VPC, Subnets(2 Private & 2 Public Subnets), Natgateway, Igw etc.
5) security_group - This Module Create all Security groups i.e for ALB, ECS  

pre-requisites.
1) Create a docker image and store it in ECR (Amazon Elastic Container Registry). Ensure you use same region where you are going to run ECS Cluster and update ARN in terraform variables.
2) Since the access is over HTTPS its recommended to create a valid certificate. in this scenario i have used self-signed certificate and steps are given below
          i) Upload self-signed certificate incase if you do not have certificate
                    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout privateKey.key -out certificate.crt
                    openssl rsa -in privateKey.key -text > private.pem
                    openssl x509 -inform PEM -in certificate.crt > public.pem
                    aws iam upload-server-certificate --server-certificate-name <certname> --certificate-body file://public.pem --private-key file://private.pem —region us-east-1
          ii) Update this ARN In terraform.

using self-signed certificate has some drawbacks while accessing it over browser. using curl with -k option can help over come this issue.

Creating Infrastructure using Terraform.
1) Clone this Repository
    git clone <repo>
2) login to the repo
    cd aws_ecs_deployment
3) Run Terraform init
     terraform init  
4) Run Terraform plan.
    terraform plan
5) Deploy Terraform
    terraform apply (confirm with yes)

Terraform will provide Load balance endpoint which can be used to access the deployed image.
curl -x https://<ALB>/index.html             
