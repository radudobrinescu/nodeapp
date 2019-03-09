provider "kubernetes" {
  config_context_auth_info = "nodeapp_kubeconfig"
  config_context_cluster   = "nodeapp_kubeconfig"
  config_path = "~/.kube/kubeconfig_nodeapp-cluster"
}

#resource "kubernetes_namespace" "elk" {
#  metadata {
#    name = "elk"
#  }

#  depends_on = ["module.eks"]
#}

#resource "kubernetes_namespace" "nodeapp" {
#  metadata {
#    name = "nodeapp"
#  }
#  depends_on = ["module.eks"]
#}

resource "kubernetes_deployment" "nodeapp-api" {
  metadata {
#    namespace = "nodeapp"
    name = "nodeapp-api"
    labels {
      app = "nodeapp"
      role = "api"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels {
      app = "nodeapp"
      role = "api"
      }
    }

    template {
      metadata {
        labels {
      app = "nodeapp"
      role = "api"
        }
      }

      spec {
        container {
          image = "049581233739.dkr.ecr.eu-central-1.amazonaws.com/nodeapprepo:apiv1"
          name  = "nodeapp-api"
          env {
             name = "DB"
             value = "postgres://nodeappadmin:nodeappadmin!@${module.db.this_db_instance_endpoint}/nodeappdb"
	  }
          port {
           container_port = 3000
	  }
          }
        }
      }
    }
  depends_on = ["module.eks"]
}

resource "kubernetes_deployment" "nodeapp-web" {
  metadata {
#    namespace = "nodeapp"
    name = "nodeapp-web"
    labels {
      app = "nodeapp"
      role = "web"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels {
      app = "nodeapp"
      role = "web"
      }
    }

    template {
      metadata {
        labels {
      app = "nodeapp"
      role = "web"
        }
      }

      spec {
        container {
          image = "049581233739.dkr.ecr.eu-central-1.amazonaws.com/nodeapprepo:webv1"
          name  = "nodeapp-web"
          env {
              name  = "API_HOST"
              value = "http://nodeapp-api-svc:3300"
              }
          env {
              name  = "PORT"
              value = "80"
          }
          port {
           container_port = 3000
	  }
          }
        }
      }
    }
  depends_on = ["module.eks"]
}

resource "kubernetes_service" "nodeapp-api-svc" {
  metadata {
#    namespace = "nodeapp"
    name = "nodeapp-api-svc"
  }
  spec {
    selector {
      role = "api"
    }
    #session_affinity = "ClientIP"
    port {
      port = 3300
      target_port = 3000
    }

    type = "ClusterIP"
  }
  depends_on = ["module.eks"]
}

resource "kubernetes_service" "nodeapp-web-svc" {
  metadata {
#    namespace = "nodeapp"
    name = "nodeapp-web-svc"
  }
  spec {
    selector {
      role = "web"
    }
    #session_affinity = "ClientIP"
    port {
      port = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
  depends_on = ["module.eks"]
}
