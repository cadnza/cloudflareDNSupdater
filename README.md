# `cloudflareDNSupdater`

Updates a DNS record of your choosing in Cloudflare. Ideal for dynamic DNS.

## Details

Thing updates the IP of your target record to the IP obtained from `dynamicdns.park-your-domain.com/getip` every 3 minutes.

## Setup

### 1. Symlink this directory and the services it contains

```
THIS NEEDS TO CHANGE #TEMP
sudo ln -s ~/Repos/cloudflareDNSupdater /etc/systemd/system/cloudflareDNSupdater
sudo ln -s ~/Repos/cloudflareDNSupdater/com.cadnza.cloudflareDNSupdater.service /etc/systemd/system/
sudo ln -s ~/Repos/cloudflareDNSupdater/com.cadnza.cloudflareDNSupdater.timer /etc/systemd/system/
```

### 2. Reload the `systemctl` daemon to make it aware of the new files

```
sudo systemctl daemon-reload
```

### 3. Write variables to files

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

### 4. Start the service

```
sudo systemctl enable /etc/systemd/system/cloudflareDNSupdater/com.cadnza.cloudflareDNSupdater.timer
```
