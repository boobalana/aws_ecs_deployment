vpc_cidr                         = "10.1.0.0/16"
private_subnet                   = { count = 2, newbits = 10, netnum = 0 }
public_subnet                    = { count = 2, newbits = 10, netnum = 4 }
vpc_name                         = "ecs_vpc"
ecs_cluster_name                 = "test-fargate-cluster"
docker_container_port            = 80
ecs_service_name                 = "test-service"
docker_image_url                 = "<ARN Docker image stored in ECR>"
memory                           = 512
desired_task_number              = 2
cpu                              = 256
certificate_arn                   = "<ARN Aws Certificate>"
