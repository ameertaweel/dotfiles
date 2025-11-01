$HOSTNAME      = "wg001"
$NTFY_URL      = "https://NTFY_DOMAIN"
$NTFY_TOPIC    = "NTFY_TOPIC"
$NTFY_USERNAME = "NTFY_USERNAME"
$NTFY_PASSWORD = "NTFY_PASSWORD"
$NTFY_MSG      = "User ``${env:USERNAME}`` logged into ``${HOSTNAME}``."
$MAX_ATTEMPTS  = 30
$TIMEOUT_SECS  = 3
$SLEEP_SECS    = 7

# Build Basic Auth Header
$HTTP_BASIC_AUTH_ASCII  = "${NTFY_USERNAME}:${NTFY_PASSWORD}"
$HTTP_BASIC_AUTH_BASE64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(${HTTP_BASIC_AUTH_ASCII}))
$HTTP_HEADERS = @{
    Authorization = "Basic ${HTTP_BASIC_AUTH_BASE64}";
    Priority = "low";
}

$success = $false

for ($i = 1; $i -le $MAX_ATTEMPTS; $i++) {
    try {
        Write-Host "Attempt ${i} of ${MAX_ATTEMPTS}..."

	# Send POST Request
	Invoke-RestMethod `
	    -Uri "${NTFY_URL}/${NTFY_TOPIC}" `
	    -Method Post `
	    -Headers ${HTTP_HEADERS} `
	    -ContentType "text/plain" `
	    -Body "${NTFY_MSG}" `
	    -TimeoutSec "${TIMEOUT_SECS}"

        $success = $true
        break
    }
    catch {
        Write-Warning "Attempt ${i} failed:`n$($_.Exception.Message)"

        if ($i -lt $MAX_ATTEMPTS) {
            Write-Host "Retrying in ${SLEEP_SECS} seconds..."
            Start-Sleep -Seconds "${SLEEP_SECS}"
        }
    }
}

if ($success) {
    Write-Host "Notification sent."
    exit 0
} else {
    Write-Error "Failed to send notification."
    exit 1
}
