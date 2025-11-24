# Script PowerShell para teste completo de todos os endpoints
$baseUrl = "http://localhost:3000"
$results = @{}
$successCount = 0
$failCount = 0

function Test-Endpoint {
    param(
        [string]$Name,
        [string]$Method,
        [string]$Endpoint,
        [hashtable]$Headers = @{},
        [string]$Body = $null
    )
    
    Write-Host "$Name..." -ForegroundColor Cyan
    
    try {
        $params = @{
            Uri = "$baseUrl$Endpoint"
            Method = $Method
            Headers = $Headers
            UseBasicParsing = $true
        }
        
        if ($Body) {
            $params["Body"] = $Body
            $params["ContentType"] = "application/json"
        }
        
        $response = Invoke-WebRequest @params
        $data = $response.Content | ConvertFrom-Json
        
        Write-Host "   ✅ $($response.StatusCode)" -ForegroundColor Green
        $script:successCount++
        return @{ success = $true; data = $data; status = $response.StatusCode }
    } catch {
        $statusCode = if ($_.Exception.Response) { $_.Exception.Response.StatusCode.value__ } else { "N/A" }
        Write-Host "   ❌ $statusCode - $($_.Exception.Message)" -ForegroundColor Red
        $script:failCount++
        return @{ success = $false; error = $_.Exception.Message; status = $statusCode }
    }
}

Write-Host "=====================================" -ForegroundColor Yellow
Write-Host "   TESTE COMPLETO DE ENDPOINTS API   " -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Yellow
Write-Host ""

# ===== AUTENTICAÇÃO =====
Write-Host "🔐 AUTENTICAÇÃO" -ForegroundColor Magenta
Write-Host ""

# 1. Registro Loja 1
$registerBody1 = @{
    name = "João Silva"
    email = "test.$(Get-Random)@loja1.com"
    password = "senha123"
    shopName = "Loja Premium"
} | ConvertTo-Json

$register1 = Test-Endpoint -Name "1. POST /auth/register (Loja 1)" -Method POST -Endpoint "/auth/register" -Body $registerBody1
$token1 = if ($register1.success) { $register1.data.access_token } else { $null }
$clientId1 = if ($register1.success) { $register1.data.client.id } else { $null }
$userId1 = if ($register1.success) { $register1.data.user.id } else { $null }
$baseUrl1 = if ($register1.success) { $register1.data.client.baseUrl } else { $null }
$email1 = if ($register1.success) { $register1.data.user.email } else { $null }
Write-Host ""

# 2. Registro Loja 2
$registerBody2 = @{
    name = "Maria Santos"
    email = "test.$(Get-Random)@loja2.com"
    password = "senha456"
    shopName = "Loja Elegante"
} | ConvertTo-Json

$register2 = Test-Endpoint -Name "2. POST /auth/register (Loja 2)" -Method POST -Endpoint "/auth/register" -Body $registerBody2
$token2 = if ($register2.success) { $register2.data.access_token } else { $null }
$clientId2 = if ($register2.success) { $register2.data.client.id } else { $null }
Write-Host ""

# 3. Login
if ($email1) {
    $loginBody = @{
        email = $email1
        password = "senha123"
    } | ConvertTo-Json
    
    Test-Endpoint -Name "3. POST /auth/login" -Method POST -Endpoint "/auth/login" -Body $loginBody
    Write-Host ""
}

# 4. Refresh Token
if ($register1.success -and $register1.data.refresh_token) {
    $refreshBody = @{
        refresh_token = $register1.data.refresh_token
    } | ConvertTo-Json
    
    Test-Endpoint -Name "4. POST /auth/refresh-token" -Method POST -Endpoint "/auth/refresh-token" -Body $refreshBody
    Write-Host ""
}

# 5. Whitelabel (Público)
if ($baseUrl1) {
    $encodedUrl = [System.Web.HttpUtility]::UrlEncode($baseUrl1)
    Test-Endpoint -Name "5. GET /auth/whitelabel/:baseUrl" -Method GET -Endpoint "/auth/whitelabel/$encodedUrl"
    Write-Host ""
}

# ===== CLIENTES =====
Write-Host "🏪 CLIENTES (LOJAS)" -ForegroundColor Magenta
Write-Host ""

# 6. Obter configurações do cliente
if ($token1 -and $clientId1) {
    Test-Endpoint -Name "6. GET /clients/:id" -Method GET -Endpoint "/clients/$clientId1" -Headers @{"Authorization"="Bearer $token1"}
    Write-Host ""
}

# 7. Atualizar configurações
if ($token1 -and $clientId1) {
    $updateBody = @{
        primaryColor = "#8B5CF6"
        secondaryColor = "#10B981"
        shopName = "Loja Premium Atualizada"
    } | ConvertTo-Json
    
    Test-Endpoint -Name "7. PUT /clients/:id/settings" -Method PUT -Endpoint "/clients/$clientId1/settings" -Headers @{"Authorization"="Bearer $token1"} -Body $updateBody
    Write-Host ""
}

# 8. Verificar atualização (whitelabel)
if ($baseUrl1) {
    $encodedUrl = [System.Web.HttpUtility]::UrlEncode($baseUrl1)
    $updated = Test-Endpoint -Name "8. GET /auth/whitelabel/:baseUrl (após update)" -Method GET -Endpoint "/auth/whitelabel/$encodedUrl"
    if ($updated.success) {
        Write-Host "   Cores: $($updated.data.primaryColor) / $($updated.data.secondaryColor)" -ForegroundColor Yellow
    }
    Write-Host ""
}

# ===== PRODUTOS =====
Write-Host "📦 PRODUTOS" -ForegroundColor Magenta
Write-Host ""

# 9. Sincronizar produtos (autenticado)
if ($token1) {
    Test-Endpoint -Name "9. POST /products/sync" -Method POST -Endpoint "/products/sync" -Headers @{"Authorization"="Bearer $token1"}
    Write-Host ""
}

# 10. Listar produtos (público)
$products = Test-Endpoint -Name "10. GET /products (público)" -Method GET -Endpoint "/products?page=1&pageSize=5"
if ($products.success) {
    Write-Host "   Total: $($products.data.total) | Página: $($products.data.products.Count) itens" -ForegroundColor Yellow
}
Write-Host ""

# 11. Obter produto específico
if ($products.success -and $products.data.products.Count -gt 0) {
    $productId = $products.data.products[0].id
    Test-Endpoint -Name "11. GET /products/:id" -Method GET -Endpoint "/products/$productId"
    Write-Host ""
}

# ===== USUÁRIOS =====
Write-Host "👤 USUÁRIOS" -ForegroundColor Magenta
Write-Host ""

# 12. Obter perfil
if ($token1) {
    Test-Endpoint -Name "12. GET /users/me" -Method GET -Endpoint "/users/me" -Headers @{"Authorization"="Bearer $token1"}
    Write-Host ""
}

# 13. Atualizar perfil
if ($token1) {
    $profileBody = @{
        name = "João Silva Atualizado"
    } | ConvertTo-Json
    
    Test-Endpoint -Name "13. PUT /users/me" -Method PUT -Endpoint "/users/me" -Headers @{"Authorization"="Bearer $token1"} -Body $profileBody
    Write-Host ""
}

# ===== RESUMO FINAL =====
Write-Host "=====================================" -ForegroundColor Yellow
Write-Host "   RESUMO DOS TESTES" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Yellow
$total = $successCount + $failCount
$successRate = if ($total -gt 0) { [math]::Round(($successCount / $total) * 100, 1) } else { 0 }

Write-Host ""
Write-Host "Total de testes: $total" -ForegroundColor White
Write-Host "Sucesso: $successCount" -ForegroundColor Green
Write-Host "Falhas: $failCount" -ForegroundColor Red
Write-Host "Taxa de sucesso: $successRate%" -ForegroundColor $(if ($successRate -eq 100) { "Green" } else { "Yellow" })
Write-Host ""

if ($failCount -eq 0) {
    Write-Host "🎉 TODOS OS ENDPOINTS FUNCIONANDO!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Alguns endpoints falharam. Verifique os logs acima." -ForegroundColor Yellow
}
Write-Host ""
