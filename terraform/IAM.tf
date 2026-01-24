data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# IAM Role
resource "aws_iam_role" "fastapi_irsa" {
  name = "fastapi-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.this.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:sub" =
            "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:aud" =
            "sts.amazonaws.com"
        }
      }
    }]
  })
}

#secrets manager permission policy
resource "aws_iam_policy" "secrets_access" {
  name = "fastapi-secretsmanager-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource = var.rds_secret_arn
    }]
  })
}

# attach policy to role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.fastapi_irsa.name
  policy_arn = aws_iam_policy.secrets_access.arn
}


#bind to SA
resource "kubernetes_service_account" "fastapi" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.fastapi_irsa.arn
    }
  }
}
