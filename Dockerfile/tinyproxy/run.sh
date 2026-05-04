#!/bin/bash
###############################################################################
# Name:         run.sh
# Author:       Daniel Middleton <daniel-middleton.com>
# Mod:          webmaster@wanjie.info
# Mod for tinyproxy 1.11.3 compatible
# Description:  Used as ENTRYPOINT from Tinyproxy's Dockerfile
# Usage:        See displayUsage function
###############################################################################

set -e

# Global vars
PROG_NAME='DockerTinyproxy'
PROXY_CONF='/etc/tinyproxy/tinyproxy.conf'

# Usage: screenOut STATUS message
screenOut() {
    local timestamp status message
    timestamp=$(date +"%H:%M:%S")

    if [ "$#" -ne 2 ]; then
        status='INFO'
        message="$1"
    else
        status="$1"
        message="$2"
    fi

    echo "[$PROG_NAME][$status][$timestamp]: $message"
}

# Usage: checkStatus $? "Error message" "Success message"
checkStatus() {
    local ret=$1
    local err_msg=$2
    local success_msg=$3

    case $ret in
        0)
            screenOut "SUCCESS" "$success_msg"
            ;;
        1)
            screenOut "ERROR" "$err_msg - Exiting..."
            exit 1
            ;;
        *)
            screenOut "ERROR" "Unrecognised return code."
            ;;
    esac
}

displayUsage() {
    echo
    echo '  Usage:'
    echo "      docker run -d --name='tinyproxy' -p <Host_Port>:8888 dannydirect/tinyproxy:latest <ACL>"
    echo
    echo "      - Set <Host_Port> to the port you wish the proxy to be accessible from."
    echo "      - Set <ACL> to 'ANY' to allow unrestricted proxy access, or one or more space seperated IP/CIDR addresses for tighter security."
    echo "      - If no ACL is provided, the ACL settings from mounted config file will be used."
    echo
    echo "      Examples:"
    echo "          docker run -d --name='tinyproxy' -p 6666:8888 dannydirect/tinyproxy:latest ANY"
    echo "          docker run -d --name='tinyproxy' -p 7777:8888 dannydirect/tinyproxy:latest 87.115.60.124"
    echo "          docker run -d --name='tinyproxy' -p 8888:8888 dannydirect/tinyproxy:latest 10.103.0.100/24 192.168.1.22/16"
    echo "          docker run -d --name='tinyproxy' -p 8888:8888 -v /path/to/tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf dannydirect/tinyproxy:latest"
    echo
}

stopService() {
    screenOut "Checking for running Tinyproxy service..."
    if [ "$(pidof tinyproxy)" ]; then
        screenOut "Found. Stopping Tinyproxy service for pre-configuration..."
        killall tinyproxy || true
        sleep 1
        screenOut "Tinyproxy service stopped."
    else
        screenOut "Tinyproxy service not running."
    fi
}

# Check if ACL argument was provided
hasAclArgument() {
    if [ "$#" -lt 1 ]; then
        return 1
    fi
    return 0
}

# Safe file modification function that works with bind mounts
modifyConfig() {
    local pattern="$1"
    local target="$2"

    # Validate inputs
    if [ -z "$target" ] || [ ! -f "$target" ]; then
        screenOut "ERROR" "Config file not found: $target"
        return 1
    fi

    local tmpfile="/tmp/tinyproxy_conf_$$.tmp"

    # Copy to temp location
    cp "$target" "$tmpfile"

    # Modify in temp location
    sed -i "$pattern" "$tmpfile"

    # Copy back
    cat "$tmpfile" > "$target"

    # Clean up
    rm -f "$tmpfile"
}

parseAccessRules() {
    local result=""
    local newline=$'\n'
    for ARG in "$@"; do
        result="${result}Allow ${ARG}${newline}"
    done
    # Remove trailing newline
    echo "${result%$'\n'}"
}

setMiscConfig() {
    # Set MinSpareServers
    if grep -q "^MinSpareServers" "$PROXY_CONF" 2>/dev/null; then
        modifyConfig 's/^MinSpareServers.*$/MinSpareServers 1/' "$PROXY_CONF"
        screenOut "INFO" "Set MinSpareServers to 1"
    fi

    # Set MaxSpareServers
    if grep -q "^MaxSpareServers" "$PROXY_CONF" 2>/dev/null; then
        modifyConfig 's/^MaxSpareServers.*$/MaxSpareServers 1/' "$PROXY_CONF"
        screenOut "INFO" "Set MaxSpareServers to 1"
    fi

    # Set StartServers
    if grep -q "^StartServers" "$PROXY_CONF" 2>/dev/null; then
        modifyConfig 's/^StartServers.*$/StartServers 1/' "$PROXY_CONF"
        screenOut "INFO" "Set StartServers to 1"
    fi
}

enableLogFile() {
    if grep -q "^LogLevel Info" "$PROXY_CONF" 2>/dev/null; then
        modifyConfig 's/^LogLevel Info$/LogLevel Connect/' "$PROXY_CONF"
        screenOut "INFO" "Enabled debug logging"
    fi
}

setAccess() {
    local parsed="$1"

    if [[ "$parsed" == *"ANY"* ]]; then
        modifyConfig 's/^Allow /#Allow /' "$PROXY_CONF"
        screenOut "INFO" "Set ACL to Allow ANY"
    elif [ -n "$parsed" ]; then
        local tmpfile="/tmp/tinyproxy_conf_$$.tmp"
        cp "$PROXY_CONF" "$tmpfile"

        local first=1
        while IFS= read -r line; do
            if [ "$first" -eq 1 ] && [[ "$line" =~ ^Allow\  && ! "$line" =~ ^# ]]; then
                echo "$parsed"
                first=0
            else
                echo "$line"
            fi
        done < "$tmpfile" > "${tmpfile}.new"

        cat "${tmpfile}.new" > "$PROXY_CONF"
        rm -f "$tmpfile" "${tmpfile}.new"

        screenOut "INFO" "Set ACL to: $parsed"
    else
        screenOut "INFO" "No ACL argument provided, using existing config ACL settings."
    fi
}

# Main execution
echo
screenOut "INFO" "$PROG_NAME script started..."

# Stop Tinyproxy if running
stopService

# Check if ACL argument was provided
if hasAclArgument "$@"; then
    screenOut "INFO" "ACL argument provided, applying access rules..."
    parsedRules=$(parseAccessRules "$@")
    screenOut "INFO" "Parsed rules: $parsedRules"
    setAccess "$parsedRules"
else
    screenOut "INFO" "No ACL argument provided, skipping ACL modification."
fi

# Enable log to file
enableLogFile

# Set miscellaneous config
setMiscConfig

# Start Tinyproxy in daemon mode
screenOut "INFO" "Starting Tinyproxy..."
tinyproxy -d

# Verify tinyproxy is running
sleep 1
if [ "$(pidof tinyproxy)" ]; then
    screenOut "SUCCESS" "Tinyproxy started successfully"
else
    screenOut "ERROR" "Tinyproxy failed to start!"
    exit 1
fi

# Keep container running
tail -f /dev/null
