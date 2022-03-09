module "haproxy-external" {
  source     = "terraform-module/release/helm"
  namespace  = "haproxy-ingress-external"
  repository = "https://haproxytech.github.io/helm-charts"

  app = {
    name             = "haproxy-ingress-external"
    version          = var.haproxy_chart_version
    create_namespace = true
    chart            = "kubernetes-ingress"
    force_update     = true
    wait             = false
    recreate_pods    = false
    deploy           = 1
  }
  values = [file("helm-values/haproxy.yaml")]
}