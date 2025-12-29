resource "aws_iam_role" "eks_dev" {
  name = "eks-dev-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::442880721659:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "eks_dev_attach" {
  role       = aws_iam_role.eks_dev.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
