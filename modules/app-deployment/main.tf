provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Redis Master Deployment
resource "kubernetes_deployment" "redis_master" {
  metadata {
    name = "redis-master"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "redis"
        role = "master"
      }
    }
    template {
      metadata {
        labels = {
          app = "redis"
          role = "master"
        }
      }
      spec {
        container {
          image = "redis:6.2"
          name  = "redis-master"
        }
      }
    }
  }
}

# Redis Slave Deployment
resource "kubernetes_deployment" "redis_slave" {
  metadata {
    name = "redis-slave"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "redis"
        role = "slave"
      }
    }
    template {
      metadata {
        labels = {
          app = "redis"
          role = "slave"
        }
      }
      spec {
        container {
          image = "gcr.io/google_samples/gb-redisslave:v1"
          name  = "redis-slave"
        }
      }
    }
  }
}

# Guestbook Frontend Deployment
resource "kubernetes_deployment" "guestbook" {
  metadata {
    name = "guestbook"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "guestbook"
      }
    }
    template {
      metadata {
        labels = {
          app = "guestbook"
        }
      }
      spec {
        container {
          image = "gcr.io/google-samples/gb-frontend:v4"
          name  = "guestbook"
        }
      }
    }
  }
}

# Services
resource "kubernetes_service" "redis_master" {
  metadata {
    name = "redis-master"
  }
  spec {
    selector = {
      app = "redis"
      role = "master"
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}

resource "kubernetes_service" "redis_slave" {
  metadata {
    name = "redis-slave"
  }
  spec {
    selector = {
      app = "redis"
      role = "slave"
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}

resource "kubernetes_service" "guestbook" {
  metadata {
    name = "guestbook"
  }
  spec {
    selector = {
      app = "guestbook"
    }
    port {
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}