# the following gimmik is necessary due to the incoherent way of
# managing NoSchedule taint between aws native api and kubenetes native api
# so we are able to set up taints for nodes that are propagated to critical addons
locals {
  taint_effect_map = {
    NO_SCHEDULE        = "NoSchedule"
    NO_EXECUTE         = "NoExecute"
    PREFER_NO_SCHEDULE = "PreferNoSchedule"
  }

  all_taints = flatten([
    for group_name, group_config in var.eks_managed_node_groups : 
    values(group_config.taints)
  ])

  addon_tolerations = [
    for t in local.all_taints : {
      key      = t.key
      operator = "Equal"
      value    = t.value
      effect   = lookup(local.taint_effect_map, t.effect, t.effect)
    }
  ]
}