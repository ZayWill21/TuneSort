
# KMS Key for EKS and ECR encryption
resource "aws_kms_key" "eks_ecr_key" {
  description             = "KMS key for EKS and ECR encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Allow EKS service to use the key",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow ECR service to use the key",
        Effect = "Allow",
        Principal = {
          Service = "ecr.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key by EKS node role",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.node_instance_role.arn
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key by EKS cluster role",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.eks_cluster_role.arn
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      }
    ]
  })

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-kms-key"
    }
  )
}

# KMS Alias for easier reference
resource "aws_kms_alias" "eks_ecr_key_alias" {
  name          = "alias/${var.stack_name}-eks-ecr-key"
  target_key_id = aws_kms_key.eks_ecr_key.key_id
}
