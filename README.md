# `cloudflareDNSupdater`

Updates a DNS record of your choosing in Cloudflare. Ideal for dynamic DNS.

## Details

Thing updates the IP of your target record to the IP obtained from `dynamicdns.park-your-domain.com/getip` every 3 minutes.

## Setup

### 1. Symlink this directory and the services it contains

```
sudo ln -s ~/Repos/cloudflareDNSupdater /etc/systemd/system/com.cadnza.cloudflareDNSupdater.service.d
sudo ln -s ~/Repos/cloudflareDNSupdater/com.cadnza.cloudflareDNSupdater.service /etc/systemd/system/
sudo ln -s ~/Repos/cloudflareDNSupdater/com.cadnza.cloudflareDNSupdater.timer /etc/systemd/system/
```

### 2. Reload the `systemctl` daemon to make it aware of the new files

```
sudo systemctl daemon-reload
```

### 3. Set environment variables

Configure the service

```
sudo systemctl edit com.cadnza.cloudflareDNSupdater.service
```

to define the following variables:

```
Environment="AUTH_EMAIL=[Your CloudFlare email]"
Environment="AUTH_KEY=[Your global API key]"
Environment="RECORD_IDENTIFIER=[The record identifier of the record you'd like to update]"
Environment="ZONE_IDENTIFIER=[The zone identifier of that record's zones]"
```

### 4. Start the service

```
sudo systemctl enable com.cadnza.cloudflareDNSupdater.timer
sudo systemctl start com.cadnza.cloudflareDNSupdater.timer
```
