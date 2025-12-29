resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-nodegroup"
  node_role_arn  = var.node_role_arn
  subnet_ids     = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  disk_size      = var.disk_size
  instance_types = var.instance_types
  capacity_type  = var.capacity_type

  labels = {
    role = "worker"
    env  = "prod"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-nodegroup"
    }
  )

  depends_on = [
    var.node_role_arn
  ]
}
