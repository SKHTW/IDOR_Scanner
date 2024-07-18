#!/bin/bash

# Define necessary variables
target_url=""
wordlist=""
http_method="GET"
output_file=""
interactive_mode="true"

# Function to display the help menu
function show_help {
    echo "Usage: $0 -u <target_url> -w <wordlist> -m <http_method> [-o <output_file>] [-i <interactive_mode>]"
    echo ""
    echo "Options:"
    echo "  -u    URL of the target web application"
    echo "  -w    Path to the custom wordlist"
    echo "  -m    HTTP method to use for the request (GET, POST, PUT, DELETE)"
    echo "  -o    Optional: output file to save the results"
    echo "  -i    Interactive mode (true or false)"
    echo "  -h    Show this help menu"
    echo ""
}

# Parse command-line arguments
while getopts "u:w:m:o:i:h" opt; do
    case ${opt} in
        u )
            target_url=$OPTARG
            ;;
        w )
            wordlist=$OPTARG
            ;;
        m )
            http_method=$OPTARG
            ;;
        o )
            output_file=$OPTARG
            ;;
        i )
            interactive_mode=$OPTARG
            ;;
        h )
            show_help
            exit 0
            ;;
        \? )
            echo "Invalid option: -$OPTARG" 1>&2
            show_help
            exit 1
            ;;
        : )
            echo "Invalid option: -$OPTARG requires an argument" 1>&2
            show_help
            exit 1
            ;;
    esac
done

# Ensure required parameters are provided
if [[ -z "$target_url" || -z "$wordlist" || -z "$http_method" ]]; then
    echo "Error: Missing required parameters" 1>&2
    show_help
    exit 1
fi

# Function to perform the IDOR scan interactively
function scan_idor_interactive {
    local url=$1
    local wordlist=$2
    local method=$3
    local output=$4

    echo "Starting IDOR scan on ${url} with method ${method}..."

    while IFS= read -r line; do
        full_url="${url}/${line}"
        response=$(curl -s -o /dev/null -w "%{http_code}" -X ${method} ${full_url})

        if [[ ${response} -eq 200 ]]; then
            echo "[+] Potential IDOR vulnerability found: ${full_url} (HTTP ${response})"
            if [[ -n "$output" ]]; then
                echo "${full_url} (HTTP ${response})" >> "${output}"
            fi
        else
            echo "[-] ${full_url} (HTTP ${response})"
        fi

        read -p "Press Enter to continue to the next URL..." 
    done < "${wordlist}"

    echo "IDOR scan completed."
}

# Function to perform the IDOR scan non-interactively
function scan_idor_non_interactive {
    local url=$1
    local wordlist=$2
    local method=$3
    local output=$4

    echo "Starting IDOR scan on ${url} with method ${method}..."

    while IFS= read -r line; do
        full_url="${url}/${line}"
        response=$(curl -s -o /dev/null -w "%{http_code}" -X ${method} ${full_url})

        if [[ ${response} -eq 200 ]]; then
            echo "[+] Potential IDOR vulnerability found: ${full_url} (HTTP ${response})"
            if [[ -n "$output" ]]; then
                echo "${full_url} (HTTP ${response})" >> "${output}"
            fi
        fi
    done < "${wordlist}"

    echo "IDOR scan completed."
}

# Determine whether to run in interactive or non-interactive mode
if [[ "${interactive_mode}" == "true" ]]; then
    scan_idor_interactive "${target_url}" "${wordlist}" "${http_method}" "${output_file}"
else
    scan_idor_non_interactive "${target_url}" "${wordlist}" "${http_method}" "${output_file}"
fi
