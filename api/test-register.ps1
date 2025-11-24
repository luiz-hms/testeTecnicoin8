try {
    $body = @{
        name = "Test User Complete"
        email = "complete.user@example.com"
        password = "senha123456"
        shopName = "Complete Shop"
    } | ConvertTo-Json
    
    Write-Host "Body:" -ForegroundColor Cyan
    Write-Host $body
    Write-Host ""
    
    $response = Invoke-RestMethod -Uri "http://localhost:3000/auth/register" -Method POST -Body $body -ContentType "application/json" -Verbose
    
    Write-Host "Success!" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10 | Out-File "register_response.json" -Encoding UTF8
    Write-Host "Response saved to register_response.json"
    
} catch {
    Write-Host "Error:" -ForegroundColor Red
    Write-Host $_.Exception.Message
    Write-Host ""
    if ($_.ErrorDetails.Message) {
        Write-Host "Details:" -ForegroundColor Yellow
        Write-Host $_.ErrorDetails.Message
    }
}
