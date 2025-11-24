# Test all endpoints - Simplified
$baseUrl = "http://localhost:3000"
$allPassed = $true

Write-Host "Testing API Endpoints..." -ForegroundColor Cyan
Write-Host ""

# 1. Register
Write-Host "1. POST /auth/register..." -NoNewline
try {
    $body = '{"name":"Test User","email":"test' + (Get-Random) + '@test.com","password":"senha123","shopName":"TestShop"}'
    $r = Invoke-RestMethod -Uri "$baseUrl/auth/register" -Method POST -Body $body -ContentType "application/json"
    $token = $r.access_token
    $clientId = $r.client.id
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " FAIL: $_" -ForegroundColor Red
    $allPassed = $false
}

# 2. Login
Write-Host "2. POST /auth/login..." -NoNewline
try {
    $body = "{`"email`":`"$($r.user.email)`",`"password`":`"senha123`"}"
    Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method POST -Body $body -ContentType "application/json" | Out-Null
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " FAIL: $_" -ForegroundColor Red
    $allPassed = $false
}

# 3. Get client
Write-Host "3. GET /clients/:id..." -NoNewline
try {
    Invoke-RestMethod -Uri "$baseUrl/clients/$clientId" -Headers @{Authorization="Bearer $token"} | Out-Null
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " FAIL: $_" -ForegroundColor Red
    $allPassed = $false
}

# 4. Update client settings
Write-Host "4. PUT /clients/:id/settings..." -NoNewline
try {
    $body = '{"primaryColor":"#8B5CF6","secondaryColor":"#10B981"}'
    Invoke-RestMethod -Uri "$baseUrl/clients/$clientId/settings" -Method PUT -Body $body -ContentType "application/json" -Headers @{Authorization="Bearer $token"} | Out-Null
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " FAIL: $_" -ForegroundColor Red
    $allPassed = $false
}

# 5. Get whitelabel
Write-Host "5. GET /auth/whitelabel/:url..." -NoNewline
try {
    $encodedUrl = [uri]::EscapeDataString($r.client.baseUrl)
    Invoke-RestMethod -Uri "$baseUrl/auth/whitelabel/$encodedUrl" | Out-Null
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " FAIL: $_" -ForegroundColor Red
    $allPassed = $false
}

# 6. List products
Write-Host "6. GET /products..." -NoNewline
try {
    Invoke-RestMethod -Uri "$baseUrl/products?page=1&pageSize=5" | Out-Null
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " FAIL: $_" -ForegroundColor Red
    $allPassed = $false
}

# 7. Get user profile
Write-Host "7. GET /users/me..." -NoNewline
try {
    Invoke-RestMethod -Uri "$baseUrl/users/me" -Headers @{Authorization="Bearer $token"} | Out-Null
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " FAIL: $_" -ForegroundColor Red
    $allPassed = $false
}

# 8. Update user profile
Write-Host "8. PUT /users/me..." -NoNewline
try {
    $body = '{"name":"Test User Updated"}'
    Invoke-RestMethod -Uri "$baseUrl/users/me" -Method PUT -Body $body -ContentType "application/json" -Headers @{Authorization="Bearer $token"} | Out-Null
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " FAIL: $_" -ForegroundColor Red
    $allPassed = $false
}

Write-Host ""
if ($allPassed) {
    Write-Host "All tests PASSED!" -ForegroundColor Green
} else {
    Write-Host "Some tests FAILED!" -ForegroundColor Red
}
