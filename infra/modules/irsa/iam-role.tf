resource "aws_iam_role" "irsa" {
  name = "eks-irsa-s3-reader"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.eks.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${replace(var.oidc_issuer, "https://", "")}:sub": "system:serviceaccount:${var.namespace}:${var.service_account_name}",
          "${replace(var.oidc_issuer, "https://", "")}:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.irsa.name
  policy_arn = aws_iam_policy.s3_read.arn
}
