# Kustomize
Using kubctl or kustomize

## Dryrun
Outputs the yaml that will be deployed
```
kubectl kustomize ./thecompany-blue/prod
kustomize build ./thecompany-blue/prod
```

## Apply
```
# Prod
kubectl apply -k ./thecompany-blue/prod -n thecompany

# Stage
kubectl apply -k ./thecompany-blue/stage -n thecompany prod
```

## Delete
_NB: Not scoped to a namespace_
```
kubectl delete -k ./thecompany-blue/prod
```
