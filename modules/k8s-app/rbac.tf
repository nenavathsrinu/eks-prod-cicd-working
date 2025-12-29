resource "kubernetes_role_v1" "app_deployer" {
  metadata {
    name      = "app-deployer"
    namespace = "dev"
  }

  rule {
    api_groups = ["", "apps"]
    resources  = ["pods", "services", "deployments", "replicasets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_role_binding_v1" "github_actions_binding" {
  metadata {
    name      = "github-actions-binding"
    namespace = "dev"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.app_deployer.metadata[0].name
  }

  subject {
    kind      = "User"
    name      = "github-actions"
    api_group = "rbac.authorization.k8s.io"
  }
}
