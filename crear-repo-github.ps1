<#
.SYNOPSIS
  Crea en GitHub el repositorio de seguimiento del plan TPM de Sodiacero:
  README, etiquetas por pilar, milestones por fase, un issue por paso y un tablero Project.

.DESCRIPTION
  Requiere GitHub CLI con sesion iniciada y permiso de proyectos:
    winget install --id GitHub.cli
    gh auth login --web -s project
  Se puede volver a ejecutar sin duplicar: omite lo que ya existe.

.EXAMPLE
  .\crear-repo-github.ps1 -FechaInicio 2026-11-02
.EXAMPLE
  .\crear-repo-github.ps1 -SoloCsv    # solo genera plan-tpm.csv para Google Sheets o Excel
#>
param(
  [string]$Repo = "tpm-sodiacero",
  [string]$FechaInicio = "2026-11-02",
  [ValidateSet("private", "public")][string]$Visibilidad = "private",
  [string]$TituloProyecto = "TPM Sodiacero",
  [switch]$SoloCsv
)

[Console]::OutputEncoding = [Text.Encoding]::UTF8
$OutputEncoding = [Text.Encoding]::UTF8
$utf8 = New-Object System.Text.UTF8Encoding $false
$aqui = Split-Path -Parent $MyInvocation.MyCommand.Path
$plan = [IO.File]::ReadAllText((Join-Path $aqui "plan-tpm.json"), $utf8) | ConvertFrom-Json
$inicio = [datetime]::ParseExact($FechaInicio, "yyyy-MM-dd", $null)
$tmp = Join-Path $env:TEMP "tpm-sodiacero"
New-Item -ItemType Directory -Force $tmp | Out-Null

function Invoke-Gh {
  $salida = & gh @args
  if ($LASTEXITCODE -ne 0) { throw "Fallo: gh $($args -join ' ')" }
  return $salida
}

function Get-Inicio($paso) {
  if ($paso.semIni) { return $inicio.AddDays(($paso.semIni - 1) * 7) }
  return $inicio.AddMonths($paso.ini - 1)
}

function Get-Fin($paso) {
  if ($paso.semFin) { return $inicio.AddDays($paso.semFin * 7 - 1) }
  return $inicio.AddMonths($paso.fin).AddDays(-1)
}

function Get-Periodo($paso) {
  if ($paso.semIni) {
    if ($paso.semIni -eq $paso.semFin) { return "Semana $($paso.semIni)" }
    return "Semanas $($paso.semIni)-$($paso.semFin)"
  }
  if ($paso.ini -eq $paso.fin) { return "Mes $($paso.ini)" }
  return "Meses $($paso.ini)-$($paso.fin)"
}

function Get-Pilar($n) { return ($plan.pilares | Where-Object { $_.n -eq $n }).etiqueta }
function Get-Fase($n) { return ($plan.fases | Where-Object { $_.n -eq $n }).nombre }
function Get-Titulo($paso) { return "[$($paso.id)] $($paso.titulo)" }

# --- CSV para Google Sheets / Excel ---
$filas = foreach ($p in $plan.pasos) {
  [pscustomobject]@{
    ID           = $p.id
    Fase         = Get-Fase $p.fase
    Paso         = $p.titulo
    Pilar        = ($p.pilares | ForEach-Object { Get-Pilar $_ }) -join " / "
    Periodo      = Get-Periodo $p
    Inicio       = (Get-Inicio $p).ToString("yyyy-MM-dd")
    Fin          = (Get-Fin $p).ToString("yyyy-MM-dd")
    Permanente   = if ($p.permanente) { "Si" } else { "No" }
    Entregable   = $p.entregable
    Tareas       = $p.tareas -join "; "
    Responsable  = ""
    Estado       = "Pendiente"
    Avance       = "0%"
    Observaciones = ""
  }
}
$csv = Join-Path $aqui "plan-tpm.csv"
$filas | Export-Csv -Path $csv -NoTypeInformation -Encoding UTF8
Write-Host "CSV generado: $csv ($($filas.Count) pasos)"
if ($SoloCsv) { return }

# --- Repositorio ---
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI no esta instalado. Ejecuta: winget install --id GitHub.cli"
}
$owner = Invoke-Gh api user --jq .login
$full = "$owner/$Repo"
Write-Host "Cuenta GitHub: $owner"

gh repo view $full --json name 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
  Invoke-Gh repo create $full "--$Visibilidad" --description "Plan de implementacion TPM - Sodiacero" | Out-Null
  Write-Host "Repositorio creado: $full ($Visibilidad)"
} else {
  Write-Host "Repositorio ya existe: $full"
}

function Publish-Archivo($nombre) {
  $ruta = Join-Path $aqui $nombre
  if (-not (Test-Path $ruta)) { return }
  $cuerpo = @{
    message = "Actualiza $nombre"
    content = [Convert]::ToBase64String([IO.File]::ReadAllBytes($ruta))
  }
  $sha = gh api "repos/$full/contents/$nombre" --jq .sha 2>$null
  if ($LASTEXITCODE -eq 0 -and $sha) { $cuerpo.sha = "$sha".Trim() }
  $json = Join-Path $tmp "contenido.json"
  [IO.File]::WriteAllText($json, ($cuerpo | ConvertTo-Json -Compress), $utf8)
  Invoke-Gh api -X PUT "repos/$full/contents/$nombre" --input $json --silent | Out-Null
  Write-Host "  Archivo publicado: $nombre"
}
foreach ($a in @("README.md", "plan-tpm.json", "plan-tpm.csv", "crear-repo-github.ps1")) { Publish-Archivo $a }

# --- Etiquetas ---
foreach ($p in $plan.pilares) {
  Invoke-Gh label create $p.etiqueta --repo $full --color $p.color --description $p.descripcion --force | Out-Null
}
Invoke-Gh label create "Permanente" --repo $full --color "ededed" --description "Rutina que continua despues de implementada" --force | Out-Null
Write-Host "Etiquetas listas"

# --- Milestones ---
$existentes = Invoke-Gh api "repos/$full/milestones?state=all&per_page=100" | ConvertFrom-Json
foreach ($f in $plan.fases) {
  if ($existentes | Where-Object { $_.title -eq $f.nombre }) { continue }
  $vence = $inicio.AddMonths($f.finMes).AddDays(-1).ToString("yyyy-MM-dd") + "T23:59:59Z"
  Invoke-Gh api "repos/$full/milestones" -f "title=$($f.nombre)" -f "description=$($f.descripcion)" -f "due_on=$vence" --silent | Out-Null
}
Write-Host "Milestones listos"

# --- Issues ---
$issues = @{}
foreach ($i in (Invoke-Gh issue list --repo $full --state all --limit 500 --json "title,url" | ConvertFrom-Json)) {
  $issues[$i.title] = $i.url
}
foreach ($p in $plan.pasos) {
  $titulo = Get-Titulo $p
  if ($issues.ContainsKey($titulo)) { continue }
  $pilares = $p.pilares | ForEach-Object { Get-Pilar $_ }
  $cuerpo = @(
    "**Fase:** $(Get-Fase $p.fase)"
    "**Pilar:** $($pilares -join ', ')"
    "**Periodo:** $(Get-Periodo $p) ($((Get-Inicio $p).ToString('yyyy-MM-dd')) a $((Get-Fin $p).ToString('yyyy-MM-dd')))"
    "**Entregable:** $($p.entregable)"
    ""
    "### Tareas"
    ($p.tareas | ForEach-Object { "- [ ] $_" })
    ""
    "### Cierre"
    "- [ ] Responsable definido"
    "- [ ] Entregable elaborado y adjunto como comentario (foto, formato o archivo)"
    "- [ ] Revisado y aprobado en el Comite TPM"
  )
  if ($p.permanente) {
    $cuerpo += ""
    $cuerpo += "> **Actividad permanente:** cerrar este issue cuando la rutina este implementada y funcionando. Su cumplimiento se sigue luego en los indicadores."
  }
  $archivo = Join-Path $tmp "issue.md"
  [IO.File]::WriteAllText($archivo, ($cuerpo -join "`n"), $utf8)
  $etiquetas = @($pilares)
  if ($p.permanente) { $etiquetas += "Permanente" }
  $ghArgs = @("issue", "create", "--repo", $full, "--title", $titulo, "--body-file", $archivo, "--milestone", (Get-Fase $p.fase))
  foreach ($e in $etiquetas) { $ghArgs += @("--label", $e) }
  $url = (Invoke-Gh @ghArgs | Select-Object -Last 1).Trim()
  $issues[$titulo] = $url
  Write-Host "  Issue creado: $titulo"
  Start-Sleep -Milliseconds 800
}
Write-Host "Issues listos: $($plan.pasos.Count)"

# --- Tablero Project ---
$proyectos = (Invoke-Gh project list --owner $owner --format json --limit 100 | ConvertFrom-Json).projects
$proyecto = $proyectos | Where-Object { $_.title -eq $TituloProyecto } | Select-Object -First 1
if (-not $proyecto) {
  $proyecto = Invoke-Gh project create --owner $owner --title $TituloProyecto --format json | ConvertFrom-Json
  Write-Host "Project creado: $TituloProyecto"
}
$num = $proyecto.number
gh project link $num --owner $owner --repo $full 2>$null | Out-Null

function Get-Campos { return (Invoke-Gh project field-list $num --owner $owner --format json --limit 50 | ConvertFrom-Json).fields }
$campos = Get-Campos
$nuevos = @(
  @{ nombre = "Inicio"; tipo = "DATE" },
  @{ nombre = "Fin"; tipo = "DATE" },
  @{ nombre = "Fase"; tipo = "SINGLE_SELECT"; opciones = ($plan.fases | ForEach-Object { $_.nombre }) -join "," },
  @{ nombre = "Pilar"; tipo = "SINGLE_SELECT"; opciones = ($plan.pilares | ForEach-Object { $_.etiqueta }) -join "," }
)
foreach ($c in $nuevos) {
  if ($campos | Where-Object { $_.name -eq $c.nombre }) { continue }
  $cArgs = @("project", "field-create", $num, "--owner", $owner, "--name", $c.nombre, "--data-type", $c.tipo)
  if ($c.opciones) { $cArgs += @("--single-select-options", $c.opciones) }
  Invoke-Gh @cArgs | Out-Null
}
$campos = Get-Campos
$cInicio = $campos | Where-Object { $_.name -eq "Inicio" }
$cFin = $campos | Where-Object { $_.name -eq "Fin" }
$cFase = $campos | Where-Object { $_.name -eq "Fase" }
$cPilar = $campos | Where-Object { $_.name -eq "Pilar" }
$cEstado = $campos | Where-Object { $_.name -eq "Status" }
$opPendiente = $cEstado.options | Where-Object { $_.name -eq "Todo" } | Select-Object -First 1

foreach ($p in $plan.pasos) {
  $item = Invoke-Gh project item-add $num --owner $owner --url $issues[(Get-Titulo $p)] --format json | ConvertFrom-Json
  $opFase = $cFase.options | Where-Object { $_.name -eq (Get-Fase $p.fase) }
  $opPilar = $cPilar.options | Where-Object { $_.name -eq (Get-Pilar $p.pilares[0]) }
  $valores = @(
    @("--field-id", $cInicio.id, "--date", (Get-Inicio $p).ToString("yyyy-MM-dd")),
    @("--field-id", $cFin.id, "--date", (Get-Fin $p).ToString("yyyy-MM-dd")),
    @("--field-id", $cFase.id, "--single-select-option-id", $opFase.id),
    @("--field-id", $cPilar.id, "--single-select-option-id", $opPilar.id)
  )
  if ($opPendiente) { $valores += , @("--field-id", $cEstado.id, "--single-select-option-id", $opPendiente.id) }
  foreach ($v in $valores) {
    $eArgs = @("project", "item-edit", "--id", $item.id, "--project-id", $proyecto.id) + $v
    Invoke-Gh @eArgs | Out-Null
  }
  Write-Host "  En tablero: $($p.id)"
}

Write-Host ""
Write-Host "Listo."
Write-Host "Repositorio: https://github.com/$full"
Write-Host "Tablero:     $($proyecto.url)"
