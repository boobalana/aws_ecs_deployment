# AWS ECS with terraform

Using this Repository we can create ECS Cluster using terraform.


Here we use modules to create all AWS service so later while creating multiple environment we do not need to rewrite entire code it can be reused .

# List of Modules.
* ecs - User for Creating ECS cluster, Service and task-definition
* iam - Used for creating IAM Roles for services to connect with other service.
* loadbalancer - Used for Creating Application loadbalancer (ALB).
* networking - Used for creating a VPC, Subnets(2 Private & 2 Public Subnets), Natgateway, Igw etc.
* security_group - Used for Creating all Security groups (i.e) ALB, ECS  

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.15.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.15.1 |

### Pre-requisites.
1)  Create a docker image and store it in ECR (Amazon Elastic Container Registry). Ensure you use same region where you are going to run ECS Cluster and update ARN in terraform variables file.

2) Access to endpoint is over HTTPS its recommended to create a valid certificate. in this scenario i have used self-signed certificate and steps are given below.
#### Upload self-signed certificate incase if you do not have certificate
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout privateKey.key -out certificate.crt
openssl rsa -in privateKey.key -text > private.pem
openssl x509 -inform PEM -in certificate.crt > public.pem
aws iam upload-server-certificate --server-certificate-name <certname> --certificate-body file://public.pem --private-key file://private.pem —region us-east-1
```
Update this ARN In terraform variables file.

Using self-signed certificate has some drawbacks while accessing it over browser. using curl with -k option can help over come this issue.
### Terraform statefile.
i am not using remote state. here all state files are stored locally. enabling remote state can be done by adding the file given below  backend.tf this will enable remote state. 
```
backend.tf

terraform {
  backend "s3" {
    bucket         = "<s3 bucketname>"
    key            = "<path to store statefile>"
    region         = "<Region>"
    encrypt        = true
    dynamodb_table = "<dynamodb table>"
  }
}
```
## Creating Infrastructure using Terraform.
 * Clone this Repository
    ```git clone <repo>```
 * login to the repo
    ```cd aws_ecs_deployment```
 * Run Terraform init
    ```terraform init```  
 * Run Terraform plan.
   ```terraform plan```
 * Deploy Terraform
    ```terraform apply (confirm with yes)```

Terraform will provide Load balance endpoint as output which can be used to access the deployed image.
* curl -x https://<ALB>/index.html        
