data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name
  name_prefix = "serverless-jenkins"

  tags = {
    team     = "itagile"
    solution = "jenkins"
  }
}

// An example of creating a KMS key
resource "aws_kms_key" "efs_kms_key" {
  description = "KMS key used to encrypt Jenkins EFS volume"
}

module "serverless_jenkins" {
  source                          = "../modules/jenkins_platform"
  name_prefix                     = local.name_prefix
  tags                            = local.tags
  vpc_id                          = var.vpc_id
  efs_kms_key_arn                 = aws_kms_key.efs_kms_key.arn
  efs_subnet_ids                  = var.efs_subnet_ids
  jenkins_controller_subnet_ids   = var.jenkins_controller_subnet_ids
  alb_subnet_ids                  = var.alb_subnet_ids
  alb_ingress_allow_cidrs         = ["0.0.0.0/0"]
#  alb_acm_certificate_arn         = "test"
  route53_create_alias            = true
  route53_alias_name              = var.jenkins_dns_alias
  route53_zone_id                 = var.route53_zone_id
}

