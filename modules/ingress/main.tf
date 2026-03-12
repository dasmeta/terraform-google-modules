locals {
  default_annotation = {
    "kubernetes.io/ingress.class"                 = "nginx"
    "kubernetes.io/ingress.global-static-ip-name" = "web-static-ip6"
    "kubernetes.io/ingress.allow-http"            = "true"
    "ingress.kubernetes.io/proxy-body-size"       = "10m"
    "ingress.kubernetes.io/ssl-redirect"          = "true"
    "ingress.kubernetes.io/affinity"              = "cookie"
    "ingress.kubernetes.io/session-cookie-name"   = "route"
    "ingress.kubernetes.io/session-cookie-hash"   = "sha1"
    "nginx.ingress.kubernetes.io/proxy-body-size" = "10"
  }
  annotations = merge(local.default_annotation, var.annotations)
}

resource "kubernetes_ingress_v1" "ingress" {

  metadata {
    name        = var.host
    annotations = local.annotations
  }

  spec {
    tls {
      hosts       = [var.host]
      secret_name = var.host
    }
    rule {
      host = var.host
      http {
        dynamic "path" {
          for_each = var.paths
          content {
            backend {
              service {
                name = path.value["service_name"]
                port {
                  number = path.value["service_port"]
                }
              }
            }
            path = path.value["path"]
          }
        }

      }
    }
  }
}
