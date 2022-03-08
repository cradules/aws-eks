# Install haproxy external
module "haproxy-external" {
  source     = "terraform-module/release/helm"
  namespace  = "haproxy-ingress-external"
  repository = "https://haproxytech.github.io/helm-charts"

  app = {
    name             = "haproxy-ingress-external"
    version          = "1.19.0"
    create_namespace = true
    chart            = "kubernetes-ingress"
    force_update     = true
    wait             = false
    recreate_pods    = true
    deploy           = 1
  }
  values = [file("helm-values/haproxy.yaml")]
}