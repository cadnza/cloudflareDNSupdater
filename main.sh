#!/usr/bin/env bash

# Make sure files exist
filesExist=1
[ -f $auth_email ] || filesExist=0
[ -f $auth_key ] || filesExist=0
[ -f $record_identifier ] || filesExist=0
[ -f $zone_identifier ] || filesExist=0
[ $filesExist = 1 ] || {
	echo "Missing configuration file(s)"
	exit 1
}

# Make sure jq is installed
which jq &> /dev/null || {
	echo "jq not installed"
	exit 1
}

# Get IP
ip=$(curl -s dynamicdns.park-your-domain.com/getip)

# Compare IP with cached IP
doUpdate=0
fIp=ip
[ -f $fIp ] || doUpdate=1
[ $doUpdate = 0 ] && [ $(cat $fIp) = $ip ] || doUpdate=1

# Return if no update needed
[ $doUpdate = 0 ] && exit 0

# Format data
data=$(
	echo "{
		\"content\": \"$ip\",
		\"name\": \"access\",
		\"proxied\": false,
		\"type\": \"A\",
		\"comment\": \"Auto-updated domain verification record\",
		\"ttl\": 1
	}" | jq -r
)

# Update record
response=$(
	curl -s --request PUT \
		--url "https://api.cloudflare.com/client/v4/zones/$(cat zone_identifier)/dns_records/$(cat record_identifier)" \
		--header "Content-Type: application/json" \
		--header "X-Auth-Key: $(cat auth_key)" \
		--header "X-Auth-Email: $(cat auth_email)" \
		--data "$data"
)

# Check for success
[ $(echo $response | jq '.success') = 'true' ] || {
	echo "Failed to update record"
	exit 1
}

# Update cached IP
echo $ip > $fIp

# Exit
exit 0
