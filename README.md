# `cloudflareDNSupdater`

Updates a DNS record of your choosing in Cloudflare. Ideal for dynamic DNS.

## Details

Thing updates the IP of your target record to the IP obtained from `dynamicdns.park-your-domain.com/getip` every 3 minutes.

## Setup

### 1. Symlink this directory into `system`

```
ln -s . /etc/systemd/system
```

### 2. Write variables to files

```
echo "[your Cloudflare email]" > auth_email
```

```
echo "[your global API key]" > auth_key
```

```
echo "[the record identifier of your target DNS record]" > record_identifier
```

```
echo "[the zone identifier of your record's zone]" > zone_identifier
```

### 3. Start the service

```
sudo systemctl enable /etc/systemd/service/cloudflareDNSupdater/com.cadnza/cloudflareDNSupdater.service
```
