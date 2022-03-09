module "prometheus" {
  source     = "terraform-module/release/helm"
  namespace  = "prometheus"
  repository = "https://prometheus.github.io/helm-charts"

  app = {
    name             = "prometheus"
    version          = var.prometheus_chart_version
    create_namespace = true
    chart            = "prometheus"
    force_update     = true
    wait             = false
    recreate_pods    = false
    deploy           = 1
  }
  values = [file("helm-values/prometheus.yaml")]
}