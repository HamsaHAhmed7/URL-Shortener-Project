module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "endpoints" {
  source                 = "./modules/endpoints"
  vpc_id                 = module.vpc.vpc_id
  ecs_sg_id              = module.sg.ecs_sg_id
  vpc_endpoint_sg_id     = module.sg.vpc_endpoint_sg_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  private_route_table_id = module.vpc.private_route_table_id
}

module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  alb_sg_id           = module.sg.alb_sg_id
  acm_certificate_arn = module.acm.certificate_arn
}


module "ecs" {
  source                = "./modules/ecs"
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.sg.ecs_sg_id
  dynamodb_table_name   = module.dynamodb.table_name

  target_group_arn = module.alb.target_group_arn_blue
}

module "codedeploy" {
  source                  = "./modules/codedeploy"
  ecs_cluster_name        = module.ecs.ecs_cluster_name
  ecs_service_name        = module.ecs.ecs_service_name
  target_group_blue_name  = "url-blue"
  target_group_green_name = "url-green"
  listener_arn            = module.alb.listener_arn_blue
}

module "route53" {
  source       = "./modules/route53"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = "Z35SXDOTRQ7X7K" # ELB zone ID for us-east-1
}



module "acm" {
  source      = "./modules/acm"
  domain_name = "url-shortener.hamsa-ahmed.co.uk"
  zone_id     = data.aws_route53_zone.url_zone.id
}

data "aws_route53_zone" "url_zone" {
  name         = "hamsa-ahmed.co.uk"
  private_zone = false
}

module "waf" {
  source  = "./modules/waf"
  alb_arn = module.alb.alb_arn
}