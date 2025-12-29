resource "aws_iam_openid_connect_provider" "eks" {
  url             = var.oidc_issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0ecd5e3d8"]
}
