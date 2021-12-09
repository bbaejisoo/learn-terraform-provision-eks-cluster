output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "cluster_name" {
  value = "${local.cluster_name}"
}

output "region" {
  description = "AWS region"
  value = "${var.region}"
}
