# Script para capturar JSONs de retorno de todos os endpoints
$baseUrl = "http://localhost:3000"
$outputFile = "api_responses_complete.json"
$responses = @{}

function Capture-Response {
    param(
        [string]$Name,
        [string]$Method,
        [string]$Endpoint,
        [hashtable]$Headers = @{},
        [string]$Body = $null
    )
    
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
        
        return @{
            status = $response.StatusCode
            success = $true
            response = $data
        }
    } catch {
        $errorBody = $null
        if ($_.ErrorDetails.Message) {
            try {
                $errorBody = $_.ErrorDetails.Message | ConvertFrom-Json
            } catch {
                $errorBody = $_.ErrorDetails.Message
            }
        }
        
        return @{
            status = if ($_.Exception.Response) { $_.Exception.Response.StatusCode.value__ } else { 500 }
            success = $false
            error = $_.Exception.Message
            errorBody = $errorBody
        }
    }
}

Write-Host "Capturando respostas JSON de todos os endpoints..." -ForegroundColor Cyan
Write-Host ""

# 1. REGISTER
Write-Host "1. POST /auth/register..." -NoNewline
$registerBody = @{
    name = "Test User Complete"
    email = "complete.test.$(Get-Random)@example.com"
    password = "senha123456"
    shopName = "Complete Test Shop"
} | ConvertTo-Json

$register = Capture-Response -Name "register" -Method POST -Endpoint "/auth/register" -Body $registerBody
$responses["1_POST_auth_register"] = $register
$token = if ($register.success) { $register.response.access_token } else { $null }
$refreshToken = if ($register.success) { $register.response.refresh_token } else { $null }
$clientId = if ($register.success) { $register.response.client.id } else { $null }
$userId = if ($register.success) { $register.response.user.id } else { $null }
$email = if ($register.success) { $register.response.user.email } else { $null }
$baseUrlClient = if ($register.success) { $register.response.client.baseUrl } else { $null }
Write-Host " ✓" -ForegroundColor Green

# 2. LOGIN
Write-Host "2. POST /auth/login..." -NoNewline
if ($email) {
    $loginBody = @{
        email = $email
        password = "senha123456"
    } | ConvertTo-Json
    
    $login = Capture-Response -Name "login" -Method POST -Endpoint "/auth/login" -Body $loginBody
    $responses["2_POST_auth_login"] = $login
    Write-Host " ✓" -ForegroundColor Green
} else {
    Write-Host " SKIP" -ForegroundColor Yellow
}

# 3. REFRESH TOKEN
Write-Host "3. POST /auth/refresh-token..." -NoNewline
if ($refreshToken) {
    $refreshBody = @{
        refresh_token = $refreshToken
    } | ConvertTo-Json
    
    $refresh = Capture-Response -Name "refresh" -Method POST -Endpoint "/auth/refresh-token" -Body $refreshBody
    $responses["3_POST_auth_refresh_token"] = $refresh
    Write-Host " ✓" -ForegroundColor Green
} else {
    Write-Host " SKIP" -ForegroundColor Yellow
}

# 4. GET WHITELABEL (PUBLIC)
Write-Host "4. GET /auth/whitelabel/:baseUrl..." -NoNewline
if ($baseUrlClient) {
    $encodedUrl = [uri]::EscapeDataString($baseUrlClient)
    $whitelabel = Capture-Response -Name "whitelabel" -Method GET -Endpoint "/auth/whitelabel/$encodedUrl"
    $responses["4_GET_auth_whitelabel"] = $whitelabel
    Write-Host " ✓" -ForegroundColor Green
} else {
    Write-Host " SKIP" -ForegroundColor Yellow
}

# 5. GET CLIENT BY ID
Write-Host "5. GET /clients/:id..." -NoNewline
if ($token -and $clientId) {
    $client = Capture-Response -Name "getClient" -Method GET -Endpoint "/clients/$clientId" -Headers @{Authorization="Bearer $token"}
    $responses["5_GET_clients_id"] = $client
    Write-Host " ✓" -ForegroundColor Green
} else {
    Write-Host " SKIP" -ForegroundColor Yellow
}

# 6. UPDATE CLIENT SETTINGS
Write-Host "6. PUT /clients/:id/settings..." -NoNewline
if ($token -and $clientId) {
    $updateBody = @{
        primaryColor = "#FF6B6B"
        secondaryColor = "#4ECDC4"
        shopName = "Updated Test Shop"
    } | ConvertTo-Json
    
    $updateClient = Capture-Response -Name "updateClient" -Method PUT -Endpoint "/clients/$clientId/settings" -Headers @{Authorization="Bearer $token"} -Body $updateBody
    $responses["6_PUT_clients_id_settings"] = $updateClient
    Write-Host " ✓" -ForegroundColor Green
} else {
    Write-Host " SKIP" -ForegroundColor Yellow
}

# 7. GET WHITELABEL AFTER UPDATE
Write-Host "7. GET /auth/whitelabel/:baseUrl (after update)..." -NoNewline
if ($baseUrlClient) {
    $encodedUrl = [uri]::EscapeDataString($baseUrlClient)
    $whitelabelUpdated = Capture-Response -Name "whitelabelUpdated" -Method GET -Endpoint "/auth/whitelabel/$encodedUrl"
    $responses["7_GET_auth_whitelabel_updated"] = $whitelabelUpdated
    Write-Host " ✓" -ForegroundColor Green
} else {
    Write-Host " SKIP" -ForegroundColor Yellow
}

# 8. SYNC PRODUCTS
Write-Host "8. POST /products/sync..." -NoNewline
if ($token) {
    $sync = Capture-Response -Name "syncProducts" -Method POST -Endpoint "/products/sync" -Headers @{Authorization="Bearer $token"}
    $responses["8_POST_products_sync"] = $sync
    Write-Host " ✓" -ForegroundColor Green
} else {
    Write-Host " SKIP" -ForegroundColor Yellow
}

# 9. LIST PRODUCTS (PUBLIC)
Write-Host "9. GET /products..." -NoNewline
$products = Capture-Response -Name "listProducts" -Method GET -Endpoint "/products?page=1&pageSize=3"
$responses["9_GET_products"] = $products
$productId = if ($products.success -and $products.response.products.Count -gt 0) { $products.response.products[0].id } else { $null }
Write-Host " ✓" -ForegroundColor Green

# 10. GET PRODUCT BY ID
Write-Host "10. GET /products/:id..." -NoNewline
if ($productId) {
    $product = Capture-Response -Name "getProduct" -Method GET -Endpoint "/products/$productId"
    $responses["10_GET_products_id"] = $product
    Write-Host " ✓" -ForegroundColor Green
} else {
    Write-Host " SKIP (no products)" -ForegroundColor Yellow
}

# 11. GET USER PROFILE
Write-Host "11. GET /users/me..." -NoNewline
if ($token) {
    $profile = Capture-Response -Name "getProfile" -Method GET -Endpoint "/users/me" -Headers @{Authorization="Bearer $token"}
    $responses["11_GET_users_me"] = $profile
    Write-Host " ✓" -ForegroundColor Green
} else {
    Write-Host " SKIP" -ForegroundColor Yellow
}

# 12. UPDATE USER PROFILE
Write-Host "12. PUT /users/me..." -NoNewline
if ($token) {
    $updateProfileBody = @{
        name = "Test User Complete Updated"
    } | ConvertTo-Json
    
    $updateProfile = Capture-Response -Name "updateProfile" -Method PUT -Endpoint "/users/me" -Headers @{Authorization="Bearer $token"} -Body $updateProfileBody
    $responses["12_PUT_users_me"] = $updateProfile
    Write-Host " ✓" -ForegroundColor Green
} else {
    Write-Host " SKIP" -ForegroundColor Yellow
}

# Save to file
Write-Host ""
Write-Host "Salvando respostas em $outputFile..." -ForegroundColor Cyan
$responses | ConvertTo-Json -Depth 20 | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "✓ Concluído! Total de endpoints testados: $($responses.Count)" -ForegroundColor Green
Write-Host ""
Write-Host "Arquivo salvo: $outputFile" -ForegroundColor Yellow
