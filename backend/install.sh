OPTIND=1
TUNNEL_NAME="default"
TUNNEL_ID=""
DOMAIN="example.com"
CLOUDFLARE_CONFIG="$HOME/.cloudflared/config.yaml"
SUBDOMAINS=()
PORTS=()
PORT=1111
VERBOSE=0

while getopts "d:p:n?s?c?v?h?" opt; do
    case "$opt" in
    h|\?)
        echo "A utility script for quickly getting up and started with self-hosted applications."
        echo "This script assumes the following:"
        echo "- You have already signed in to the cloudflared CLI application;"
        echo "- You own a domain through Cloudflare;"
        echo ""
        echo "                                              |key-value pairs of sub and port"
        echo "Usage: $0 [d domain] [p port] {n tunnel_name} {s subdomain=1234}"
        echo "          {c cloudflare_config} {v verbose} {h help}"
        exit 0
        ;;
    n)  TUNNEL_NAME=$OPTARG
        ;;
    d)  DOMAIN=$OPTARG
        ;;
    c)  CLOUDFLARE_CONFIG=$OPTARG
        ;;
    v)  VERBOSE=1
        ;;
    s)  SUBDOMAINS+=("$(echo $OPTARG | cut -f1 -d=)")
        PORTS+=("$(echo $OPTARG | cut -f2 -d=)")
        ;;
    p)  PORT="$OPTARG"
        ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift
# TODO: Connect with cross-platform package manager from quaxlyqueen/scripts
# TODO: Setup ollama (pull LLM best fitting hardware).

createTunnel

# Initialize cloudflared
createTunnel() {
	if [[ "$VERBOSE" -eq 1 ]]; then
	  echo "Creating cloudflared tunnel..."
	fi
	output=$(cloudflared tunnel create $TUNNEL_NAME)
	TUNNEL_ID=$(echo "$output" | grep -o 'id [^ ]*' | awk -F ' ' '{print $2}')
	if [[ "$VERBOSE" -eq 1 ]]; then
	  echo "Created cloudflared tunnel, ID $TUNNEL_ID"
	fi

	if [[ "$VERBOSE" -eq 1 ]]; then
	  echo "Creating cloudflared tunnel credentials file..."
	fi
	echo "tunnel: $TUNNEL_ID" > $CLOUDFLARE_CONFIG
	echo "credentials-file: $HOME/.cloudflared/$TUNNEL_ID.json" >> $CLOUDFLARE_CONFIG
	echo "ingress:" >> $CLOUDFLARE_CONFIG

	# Add subdomain and associated ports
	len=${#SUBDOMAINS[@]}
	for (( i=0; i<${len}; i++ ));
	do
	  echo ${SUBDOMAINS[$i]}
	  echo ${PORTS[$i]}
	done
	echo $SUBDOMAINS
	for (( i=0; i<${len}; i++ ));
	do
	  echo "  - hostname: ${SUBDOMAINS[$i]}.$DOMAIN" >> $CLOUDFLARE_CONFIG
	  echo "    service: http://127.0.0.1:${PORTS[$i]}" >> $CLOUDFLARE_CONFIG
	  if [[ "$VERBOSE" -eq 1 ]]; then
	    echo "Associated ${SUBDOMAINS[$i]}.$DOMAIN to port ${PORTS[$i]}"
	  fi
	done

	echo "  - hostname: $DOMAIN" >> $CLOUDFLARE_CONFIG
	echo "    service: http://127.0.0.1:$PORT" >> $CLOUDFLARE_CONFIG
	echo "  - service: http_status:404" >> $CLOUDFLARE_CONFIG
	echo "Associated $DOMAIN to port $PORT"
	if [[ "$VERBOSE" -eq 1 ]]; then
	  echo "Created cloudflared tunnel credentials file"
	  cat $CLOUDFLARE_CONFIG
	fi

	if [[ "$VERBOSE" -eq 1 ]]; then
	  echo "Routing domains and sub-domains to the tunnel..."
	fi
	for (( i=0; i<${len}; i++ ));
	do
	  cloudflared tunnel route dns $TUNNEL_ID ${SUBDOMAINS[$i]}.$DOMAIN
	done
	cloudflared tunnel route dns $TUNNEL_ID $DOMAIN
	bg cloudflared tunnel run $TUNNEL_NAME

	if [[ "$VERBOSE" -eq 1 ]]; then
	  echo "Complete!"
	fi
}
