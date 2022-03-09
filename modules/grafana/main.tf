module "grafana" {
  source     = "terraform-module/release/helm"
  namespace  = "grafana"
  repository = "https://grafana.github.io/helm-charts"

  app = {
    name             = "grafana"
    version          = var.grafana_chart_version
    create_namespace = true
    chart            = "grafana"
    force_update     = true
    wait             = false
    recreate_pods    = false
    deploy           = 1
  }
  values = [file("helm-values/grafana.yaml")]
}