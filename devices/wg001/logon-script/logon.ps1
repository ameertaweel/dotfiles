$HOSTNAME      = "wg001"
$NTFY_URL      = "https://NTFY_DOMAIN"
$NTFY_TOPIC    = "NTFY_TOPIC"
$NTFY_USERNAME = "NTFY_USERNAME"
$NTFY_PASSWORD = "NTFY_PASSWORD"
$NTFY_MSG      = "User ``${env:USERNAME}`` logged into ``${HOSTNAME}``."

# Build Basic Auth Header
$HTTP_BASIC_AUTH_ASCII  = "${NTFY_USERNAME}:${NTFY_PASSWORD}"
$HTTP_BASIC_AUTH_BASE64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(${HTTP_BASIC_AUTH_ASCII}))
$HTTP_HEADERS = @{
    Authorization = "Basic ${HTTP_BASIC_AUTH_BASE64}";
    Priority = "low";
}

# Send POST Request
Invoke-RestMethod -Uri "${NTFY_URL}/${NTFY_TOPIC}" -Method Post -Headers ${HTTP_HEADERS} -Body "${NTFY_MSG}" -ContentType "text/plain"
