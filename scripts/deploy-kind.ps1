param(
  [string]$ClusterName = "testkube-samples",
  [string]$ReleaseName = "sample-app",
  [string]$ImageTag = "dev"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$backendImage = "testkube-samples-backend:$ImageTag"
$frontendImage = "testkube-samples-frontend:$ImageTag"

function Assert-Success {
  param([string]$Step)

  if ($LASTEXITCODE -ne 0) {
    throw "$Step failed with exit code $LASTEXITCODE"
  }
}

Push-Location $repoRoot
try {
  Write-Host "Building backend image $backendImage"
  docker build -f apps/api/Dockerfile -t $backendImage .
  Assert-Success "Backend image build"

  Write-Host "Building frontend image $frontendImage"
  docker build -f apps/web/Dockerfile -t $frontendImage .
  Assert-Success "Frontend image build"

  $clusters = kind get clusters
  if ($clusters -notcontains $ClusterName) {
    Write-Host "Creating kind cluster $ClusterName"
    kind create cluster --name $ClusterName
    Assert-Success "Kind cluster creation"
  }

  Write-Host "Loading images into kind"
  kind load docker-image $backendImage --name $ClusterName
  Assert-Success "Backend image load"
  kind load docker-image $frontendImage --name $ClusterName
  Assert-Success "Frontend image load"

  Write-Host "Installing Helm release $ReleaseName"
  helm upgrade --install $ReleaseName helm/app `
    --set backend.image.repository=testkube-samples-backend `
    --set backend.image.tag=$ImageTag `
    --set backend.image.pullPolicy=IfNotPresent `
    --set frontend.image.repository=testkube-samples-frontend `
    --set frontend.image.tag=$ImageTag `
    --set frontend.image.pullPolicy=IfNotPresent
  Assert-Success "Helm installation"

  Write-Host "Waiting for application workloads"
  kubectl wait --for=condition=available --timeout=180s `
    deployment/$ReleaseName-postgres `
    deployment/$ReleaseName-backend `
    deployment/$ReleaseName-frontend
  Assert-Success "Application readiness"

  Write-Host "Application is running in kind"
  Write-Host "Frontend: kubectl port-forward service/$ReleaseName-frontend 4173:4173"
  Write-Host "Backend:  kubectl port-forward service/$ReleaseName-backend 8080:8080"
}
finally {
  Pop-Location
}