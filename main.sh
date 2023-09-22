#!/usr/bin/env bash

# Make sure variables are set
varsSet=1
[ -z $AUTH_EMAIL ] && varsSet=0
[ -z $AUTH_KEY ] && varsSet=0
[ -z $RECORD_IDENTIFIER ] && varsSet=0
[ -z $ZONE_IDENTIFIER ] && varsSet=0
[ $varsSet = 1 ] || {
	echo "Please set the following vars:
	AUTH_EMAIL
	AUTH_KEY
	RECORD_IDENTIFIER
	ZONE_IDENTIFIER" >&2
	exit 1
}

# Make sure jq is installed
which jq &> /dev/null || {
	echo "jq not installed" >&2
	exit 1
}

# Create data folder
dirData=/etc/com.cadnza.cloudflareDNSupdater
[ -d $dirData ] || mkdir $dirData

# Get IP
ip=$(curl -s dynamicdns.park-your-domain.com/getip)

# Compare new IP with old IP
doUpdate=0
fIp=$dirData/ip
[ -f $fIp ] || doUpdate=1
[ $doUpdate = 0 ] && [ $(cat $fIp) = $ip ] || doUpdate=1

# Return if no update needed
[ $doUpdate = 0 ] && exit 0

# Format data
data=$(
	jq \
		-nr \
		--arg ip $ip \
		'{
			content: $ip,
			name: "access",
			proxied: false,
			type: "A",
			comment: "Auto-updated domain verification record",
			ttl: 1
		}'
)

# Update record
response=$(
	curl -s --request PUT \
		--url "https://api.cloudflare.com/client/v4/zones/$ZONE_IDENTIFIER/dns_records/$RECORD_IDENTIFIER" \
		--header "Content-Type: application/json" \
		--header "X-Auth-Key: $AUTH_KEY" \
		--header "X-Auth-Email: $AUTH_EMAIL" \
		--data "$data"
)

# Check for success
[ $(echo $response | jq '.success') = 'true' ] || {
	echo "Failed to update record" >&2
	exit 1
}

# Update stored IP
echo $ip > $fIp

# Exit
exit 0
