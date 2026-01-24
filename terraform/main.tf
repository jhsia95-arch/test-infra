provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = module.eks.cluster_auth_token  
}

provider "aws" {
  region = var.aws_region
}