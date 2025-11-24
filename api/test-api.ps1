# Script PowerShell para testar todos os endpoints da API
$baseUrl = "http://localhost:3000"
$outputFile = "api_responses.json"

# Função auxiliar para fazer requisições
function Invoke-APIRequest {
    param(
        [string]$Method,
        [string]$Endpoint,
        [string]$Body = $null,
        [string]$Token = $null,
        [string]$ContentType = "application/json"
    )
    
    $headers = @{
        "Content-Type" = $ContentType
    }
    
    if ($Token) {
        $headers["Authorization"] = "Bearer $Token"
    }
    
    try {
        $params = @{
            Uri = "$baseUrl$Endpoint"
            Method = $Method
            Headers = $headers
            UseBasicParsing = $true
        }
        
        if ($Body) {
            $params["Body"] = $Body
        }
        
        $response = Invoke-WebRequest @params
        return @{
            success = $true
            statusCode = $response.StatusCode
            data = $response.Content | ConvertFrom-Json
        }
    } catch {
        return @{
            success = $false
            statusCode = $_.Exception.Response.StatusCode.value__
            error = $_.Exception.Message
        }
    }
}

# Armazenar todos os resultados
$results = @{}

Write-Host "=== Testando Endpoints da API ===" -ForegroundColor Green
Write-Host ""

# 1. REGISTRAR LOJA 1
Write-Host "1. POST /auth/register - Registrando Loja 1..." -ForegroundColor Cyan
$registerBody1 = @{
    name = "João Silva"
    email = "joao.teste$(Get-Random)@loja1.com"
    password = "senha123"
    shopName = "Loja1"
} | ConvertTo-Json

$register1 = Invoke-APIRequest -Method POST -Endpoint "/auth/register" -Body $registerBody1
$results["1_register_loja1"] = $register1
Write-Host "Status: $($register1.statusCode)" -ForegroundColor Yellow
Write-Host ""

# Extrair tokens e IDs
$token1 = $register1.data.access_token
$refreshToken1 = $register1.data.refresh_token
$userId1 = $register1.data.user.id
$clientId1 = $register1.data.client.id
$baseUrl1 = $register1.data.client.baseUrl

# 2. REGISTRAR LOJA 2
Write-Host "2. POST /auth/register - Registrando Loja 2..." -ForegroundColor Cyan
$registerBody2 = @{
    name = "Maria Santos"
    email = "maria.teste$(Get-Random)@loja2.com"
    password = "senha123"
    shopName = "Loja Elegante"
} | ConvertTo-Json

$register2 = Invoke-APIRequest -Method POST -Endpoint "/auth/register" -Body $registerBody2
$results["2_register_loja2"] = $register2
Write-Host "Status: $($register2.statusCode)" -ForegroundColor Yellow
Write-Host ""

$token2 = $register2.data.access_token
$clientId2 = $register2.data.client.id
$baseUrl2 = $register2.data.client.baseUrl

# 3. LOGIN
Write-Host "3. POST /auth/login - Fazendo login..." -ForegroundColor Cyan
$loginBody = @{
    email = $register1.data.user.email
    password = "senha123"
} | ConvertTo-Json

$login = Invoke-APIRequest -Method POST -Endpoint "/auth/login" -Body $loginBody
$results["3_login"] = $login
Write-Host "Status: $($login.statusCode)" -ForegroundColor Yellow
Write-Host ""

# 4. REFRESH TOKEN
Write-Host "4. POST /auth/refresh-token - Renovando token..." -ForegroundColor Cyan
$refreshBody = @{
    refresh_token = $refreshToken1
} | ConvertTo-Json

$refresh = Invoke-APIRequest -Method POST -Endpoint "/auth/refresh-token" -Body $refreshBody
$results["4_refresh_token"] = $refresh
Write-Host "Status: $($refresh.statusCode)" -ForegroundColor Yellow
Write-Host ""

# 5. BUSCAR WHITELABEL (Público)
Write-Host "5. GET /auth/whitelabel/:baseUrl - Buscando config da loja..." -ForegroundColor Cyan
$encodedUrl = [System.Web.HttpUtility]::UrlEncode($baseUrl1)
$whitelabel = Invoke-APIRequest -Method GET -Endpoint "/auth/whitelabel/$encodedUrl"
$results["5_whitelabel_public"] = $whitelabel
Write-Host "Status: $($whitelabel.statusCode)" -ForegroundColor Yellow
Write-Host ""

# 6. ATUALIZAR CONFIGURAÇÕES DA LOJA 1
Write-Host "6. PUT /clients/:id/settings - Atualizando cores da loja 1..." -ForegroundColor Cyan
$settingsBody = @{
    primaryColor = "#8B5CF6"
    secondaryColor = "#10B981"
    shopName = "Loja1 Personalizada"
} | ConvertTo-Json

$updateSettings = Invoke-APIRequest -Method PUT -Endpoint "/clients/$clientId1/settings" -Body $settingsBody -Token $token1
$results["6_update_client_settings"] = $updateSettings
Write-Host "Status: $($updateSettings.statusCode)" -ForegroundColor Yellow
Write-Host ""

# 7. OBTER CONFIGURAÇÕES DO CLIENTE
Write-Host "7. GET /clients/:id - Obtendo configurações..." -ForegroundColor Cyan
$clientSettings = Invoke-APIRequest -Method GET -Endpoint "/clients/$clientId1" -Token $token1
$results["7_get_client_settings"] = $clientSettings
Write-Host "Status: $($clientSettings.statusCode)" -ForegroundColor Yellow
Write-Host ""

# 8. BUSCAR WHITELABEL APÓS ATUALIZAÇÃO
Write-Host "8. GET /auth/whitelabel/:baseUrl - Verificando mudanças..." -ForegroundColor Cyan
$whitelabelUpdated = Invoke-APIRequest -Method GET -Endpoint "/auth/whitelabel/$encodedUrl"
$results["8_whitelabel_updated"] = $whitelabelUpdated
Write-Host "Status: $($whitelabelUpdated.statusCode)" -ForegroundColor Yellow
Write-Host ""

# 9. LISTAR PRODUTOS
Write-Host "9. GET /products - Listando produtos..." -ForegroundColor Cyan
$products = Invoke-APIRequest -Method GET -Endpoint "/products?page=1&limit=5"
$results["9_list_products"] = $products
Write-Host "Status: $($products.statusCode)" -ForegroundColor Yellow
Write-Host ""

# 10. OBTER PRODUTO ESPECÍFICO
Write-Host "10. GET /products/:id - Obtendo produto específico..." -ForegroundColor Cyan
if ($products.success -and $products.data.products.Count -gt 0) {
    $productId = $products.data.products[0].id
    $product = Invoke-APIRequest -Method GET -Endpoint "/products/$productId"
    $results["10_get_product"] = $product
    Write-Host "Status: $($product.statusCode)" -ForegroundColor Yellow
}
Write-Host ""

# 11. OBTER PERFIL DO USUÁRIO
Write-Host "11. GET /users/profile - Obtendo perfil..." -ForegroundColor Cyan
$profile = Invoke-APIRequest -Method GET -Endpoint "/users/profile" -Token $token1
$results["11_get_profile"] = $profile
Write-Host "Status: $($profile.statusCode)" -ForegroundColor Yellow
Write-Host ""

# 12. ATUALIZAR PERFIL
Write-Host "12. PUT /users/profile - Atualizando perfil..." -ForegroundColor Cyan
$profileBody = @{
    name = "João Silva Atualizado"
    phone = "11999999999"
} | ConvertTo-Json

$updateProfile = Invoke-APIRequest -Method PUT -Endpoint "/users/profile" -Body $profileBody -Token $token1
$results["12_update_profile"] = $updateProfile
Write-Host "Status: $($updateProfile.statusCode)" -ForegroundColor Yellow
Write-Host ""

# Salvar resultados em arquivo JSON
Write-Host "Salvando resultados em $outputFile..." -ForegroundColor Green
$results | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host ""
Write-Host "=== Testes Completos ===" -ForegroundColor Green
Write-Host "Resultados salvos em: $outputFile" -ForegroundColor Yellow
Write-Host ""
Write-Host "Resumo:" -ForegroundColor Green
Write-Host "- Total de endpoints testados: $($results.Count)" -ForegroundColor White
$successCount = ($results.Values | Where-Object { $_.success -eq $true }).Count
Write-Host "- Sucesso: $successCount" -ForegroundColor Green
Write-Host "- Falhas: $($results.Count - $successCount)" -ForegroundColor Red
