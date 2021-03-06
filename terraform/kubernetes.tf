provider "kubernetes" {
  config_context_auth_info = "nodeapp_kubeconfig"
  config_context_cluster   = "nodeapp_kubeconfig"
  config_path = "~/.kube/kubeconfig_nodeapp-cluster"
}

resource "kubernetes_namespace" "nodeapp" {
  metadata {
    name = "nodeapp"
  }
#  depends_on = ["module.eks"]
}

resource "kubernetes_deployment" "nodeapp-api" {
  metadata {
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
          image = "${aws_ecr_repository.nodeapprepo.repository_url}:apiv1"
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
  #depends_on = ["${kubernetes_namespace.nodeapp}"]
  depends_on = ["module.ekscluster_endpoint"]
}

resource "kubernetes_deployment" "nodeapp-web" {
  metadata {
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
          image = "${aws_ecr_repository.nodeapprepo.repository_url}:webv1"
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
  #depends_on = ["${kubernetes_namespace.nodeapp}"]
  depends_on = ["module.eks.cluster_endpoint"]
}

resource "kubernetes_service" "nodeapp-api-svc" {
  metadata {
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
  #depends_on = ["${kubernetes_namespace.nodeapp}"]
  depends_on = ["module.eks.cluster_endpoint"]
}

resource "kubernetes_service" "nodeapp-web-svc" {
  metadata {
    name = "nodeapp-web-svc"
  }
  spec {
    selector {
      app = "web"
    }
    #session_affinity = "ClientIP"
    port {
      port = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
  #depends_on = ["${kubernetes_namespace.nodeapp}"]
  depends_on = ["module.eks.cluster_endpoint"]
}
