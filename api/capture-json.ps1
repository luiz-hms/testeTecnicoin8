$baseUrl = "http://localhost:3000"
$output = @{}

# Helper function
function Call-API {
    param($method, $endpoint, $body = $null, $token = $null)
    
    $headers = @{"Content-Type" = "application/json"}
    if ($token) { $headers["Authorization"] = "Bearer $token" }
    
    try {
        $params = @{
            Uri = "$baseUrl$endpoint"
            Method = $method
            Headers = $headers
            UseBasicParsing = $true
        }
        if ($body) { $params["Body"] = $body }
        
        $r = Invoke-RestMethod @params
        return @{success=$true; data=$r}
    } catch {
        return @{success=$false; error=$_.Exception.Message}
    }
}

Write-Host "Capturando respostas..." -ForegroundColor Cyan

# 1. Register
$body = '{"name":"User Test","email":"test' + (Get-Random) + '@test.com","password":"senha123","shopName":"TestShop"}'
$r1 = Call-API "POST" "/auth/register" $body
$output["1_register"] = $r1
$token = $r1.data.access_token
$clientId = $r1.data.client.id
$email = $r1.data.user.email
$baseUrl2 = $r1.data.client.baseUrl
Write-Host "1. Register: OK"

# 2. Login
$body = "{`"email`":`"$email`",`"password`":`"senha123`"}"
$r2 = Call-API "POST" "/auth/login" $body
$output["2_login"] = $r2
Write-Host "2. Login: OK"

# 3. Refresh
$body = "{`"refresh_token`":`"$($r1.data.refresh_token)`"}"
$r3 = Call-API "POST" "/auth/refresh-token" $body
$output["3_refresh"] = $r3
Write-Host "3. Refresh: OK"

# 4. Whitelabel
$url = [uri]::EscapeDataString($baseUrl2)
$r4 = Call-API "GET" "/auth/whitelabel/$url"
$output["4_whitelabel"] = $r4
Write-Host "4. Whitelabel: OK"

# 5. Get client
$r5 = Call-API "GET" "/clients/$clientId" $null $token
$output["5_get_client"] = $r5
Write-Host "5. Get Client: OK"

# 6. Update client
$body = '{"primaryColor":"#FF6B6B","secondaryColor":"#4ECDC4"}'
$r6 = Call-API "PUT" "/clients/$clientId/settings" $body $token
$output["6_update_client"] = $r6
Write-Host "6. Update Client: OK"

# 7. Whitelabel updated
$r7 = Call-API "GET" "/auth/whitelabel/$url"
$output["7_whitelabel_updated"] = $r7
Write-Host "7. Whitelabel Updated: OK"

# 8. Sync products
$r8 = Call-API "POST" "/products/sync" $null $token
$output["8_sync_products"] = $r8
Write-Host "8. Sync Products: OK"

# 9. List products
$r9 = Call-API "GET" "/products?page=1&pageSize=2"
$output["9_list_products"] = $r9
Write-Host "9. List Products: OK"

# 10. Get product
if ($r9.data.products.Count -gt 0) {
    $pid = $r9.data.products[0].id
    $r10 = Call-API "GET" "/products/$pid"
    $output["10_get_product"] = $r10
    Write-Host "10. Get Product: OK"
}

# 11. Get profile
$r11 = Call-API "GET" "/users/me" $null $token
$output["11_profile"] = $r11
Write-Host "11. Profile: OK"

# 12. Update profile
$body = '{"name":"User Test Updated"}'
$r12 = Call-API "PUT" "/users/me" $body $token
$output["12_update_profile"] = $r12
Write-Host "12. Update Profile: OK"

# Save
$output | ConvertTo-Json -Depth 10 | Out-File "api_responses_complete.json" -Encoding UTF8
Write-Host "`nSalvo em: api_responses_complete.json" -ForegroundColor Green
