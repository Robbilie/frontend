#!/bin/sh

set -e

# Check if config.json is mounted
if mount | grep '/static/config.json'; then
    echo "config.json is mounted from host - ENV configuration will be ignored"
else
    # Apply ENV vars to temporary config.json
    jq  --arg apiBaseUrl          "$API_BASE_URL" \
        --arg oidcIssuer          "$OIDC_ISSUER" \
        --arg oidcClientId        "$OIDC_CLIENT_ID" \
        --arg oidcScope           "$OIDC_SCOPE" \
        --arg oidcFlow            "$OIDC_FLOW" \
        --arg oidcLoginButtonText "$OIDC_LOGIN_BUTTON_TEXT" \
        '.API_BASE_URL                = $apiBaseUrl 
            | .OIDC_ISSUER            = $oidcIssuer 
            | .OIDC_CLIENT_ID         = $oidcClientId 
            | .OIDC_SCOPE             = $oidcScope 
            | .OIDC_FLOW              = $oidcFlow 
            | .OIDC_LOGIN_BUTTON_TEXT = $oidcLoginButtonText' \
        ./static/config.json > /tmp/config.json

    # Override default config file
    mv -f /tmp/config.json ./static/config.json
fi

exec "$@"
