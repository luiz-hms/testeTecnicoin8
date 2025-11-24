# Script PowerShell para testar endpoints corrigidos
$baseUrl = "http://localhost:3000"

Write-Host "=== Testando Endpoints Corrigidos ===" -ForegroundColor Green
Write-Host ""

# 1. REGISTRAR NOVO USUÁRIO
Write-Host "1. POST /auth/register - Registrando teste..." -ForegroundColor Cyan
$registerBody = @{
    name = "Teste Correcao"
    email = "teste.correcao$(Get-Random)@test.com"
    password = "senha123"
    shopName = "LojaTestCorrecao"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/auth/register" -Method POST -Body $registerBody -ContentType "application/json" -UseBasicParsing
    $data = $response.Content | ConvertFrom-Json
    $token = $data.access_token
    $clientId = $data.client.id
    
    Write-Host "✅ Sucesso! ClientId: $clientId" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
    exit
}

Write-Host ""

# 2. OBTER CONFIGURAÇÕES DO CLIENTE (GET /clients/:id)
Write-Host "2. GET /clients/$clientId - Obtendo configurações..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/clients/$clientId" -Method GET -Headers @{"Authorization"="Bearer $token"} -UseBasicParsing
    $client = $response.Content | ConvertFrom-Json
    Write-Host "✅ Sucesso! ShopName: $($client.shopName)" -ForegroundColor Green
    Write-Host "   Primary Color: $($client.primaryColor)" -ForegroundColor Yellow
    Write-Host "   Secondary Color: $($client.secondaryColor)" -ForegroundColor Yellow
} catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}

Write-Host ""

# 3. ATUALIZAR CONFIGURAÇÕES (PUT /clients/:id/settings)
Write-Host "3. PUT /clients/$clientId/settings - Atualizando cores..." -ForegroundColor Cyan
$updateBody = @{
    primaryColor = "#8B5CF6"
    secondaryColor = "#10B981"
    shopName = "Loja Atualizada"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/clients/$clientId/settings" -Method PUT -Body $updateBody -Headers @{"Authorization"="Bearer $token"; "Content-Type"="application/json"} -UseBasicParsing
    $updated = $response.Content | ConvertFrom-Json
    Write-Host "✅ Sucesso! Cores atualizadas!" -ForegroundColor Green
    Write-Host "   New Primary: $($updated.primaryColor)" -ForegroundColor Magenta
    Write-Host "   New Secondary: $($updated.secondaryColor)" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}

Write-Host ""

# 4. LISTAR PRODUTOS (GET /products) - AGORA PÚBLICO
Write-Host "4. GET /products - Listando produtos (público)..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/products?page=1&pageSize=5" -Method GET -UseBasicParsing
    $products = $response.Content | ConvertFrom-Json
    Write-Host "✅ Sucesso! Total: $($products.total)" -ForegroundColor Green
    Write-Host "   Produtos na página: $($products.products.Count)" -ForegroundColor Yellow
} catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}

Write-Host ""

# 5. OBTER PERFIL (GET /users/me)
Write-Host "5. GET /users/me - Obtendo perfil..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/users/me" -Method GET -Headers @{"Authorization"="Bearer $token"} -UseBasicParsing
    $user = $response.Content | ConvertFrom-Json
    Write-Host "✅ Sucesso! User: $($user.name)" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}

Write-Host ""

# 6. ATUALIZAR PERFIL (PUT /users/me)
Write-Host "6. PUT /users/me - Atualizando perfil..." -ForegroundColor Cyan
$profileBody = @{
    name = "Teste Correcao Atualizado"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/users/me" -Method PUT -Body $profileBody -Headers @{"Authorization"="Bearer $token"; "Content-Type"="application/json"} -UseBasicParsing
    $updated = $response.Content | ConvertFrom-Json
    Write-Host "✅ Sucesso! Nome: $($updated.name)" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Testes Completos ===" -ForegroundColor Green
