resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account_v1" "this" {
  metadata {
    name      = var.service_account
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = var.irsa_role_arn
    }
  }

  depends_on = [
    kubernetes_namespace_v1.this
  ]
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        service_account_name            = var.service_account
        automount_service_account_token = true

        container {
          name    = var.app_name
          image   = var.image
          command = var.command
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace_v1.this,
    kubernetes_service_account_v1.this
  ]
}
