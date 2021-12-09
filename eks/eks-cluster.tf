provider "aws" {
  region = var.region
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${data.terraform_remote_state.vpc.outputs.cluster_name}"
  cluster_version = "1.20"
  subnets         = "${data.terraform_remote_state.vpc.outputs.private_subnets}"

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = "${data.terraform_remote_state.vpc.outputs.vpc_id}"

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 30
  }

  node_groups = {
    example = {
      desired_capacity = 3
      max_capacity     = 10
      min_capacity     = 1

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      k8s_labels = {
        Example    = "managed_node_groups"
        GithubRepo = "terraform-aws-eks"
        GithubOrg  = "terraform-aws-modules"
      }
      additional_tags = {
        ExtraTag = "example"
      }
      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "jisoo-terraform-state"
    region = "ap-northeast-2"
    key = "tfstate/terraform.tfstate"
   }
}
