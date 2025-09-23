# My `vg002` Configuration

`vg002` is a Netcup VPS 1000 ARM G11.

## First-Time Install

- Upload SSH public key to Netcup's Server Control Panel (SCP).
- Initialize the VPS with any image available in the SCP. Make sure to use the
  uploaded SSH public key.
- Set `isBeforeInstall` to `true` in `./params.nix`.
- Execute `./install.sh`.
- Once the installation finishes, you have to access the VPS via Netcup's Server
  Control Panel (SCP).
- Unlock the ZFS dataset.
- Execute `./secrets.sh`.
- Set `isBeforeInstall` to `false` in `./params.nix`.
- Execute `./deploy.sh`.
- Reboot the machine.
- Now you can unlock the VPS remotely via `./unlock.sh`.

## Miniflux

### Setup

Create admin account by hand

service-exec miniflux psql
service-exec miniflux pg_dump > out.sql
service-exec miniflux miniflux -config-dump
service-exec miniflux miniflux -create-admin
service-exec miniflux miniflux -flush-sessions
service-exec miniflux miniflux -healthcheck auto

### Upgrade

service-exec miniflux miniflux -flush-sessions
systemctl stop miniflux
service-exec miniflux pg_dump > out.sql

```bash
# Verify backup is working via test database
sudo -u postgres createdb miniflux_backup_test
sudo -u postgres psql miniflux_backup_test < out.sql
# Poke around in the CLI
sudo -u postgres psql miniflux_backup_test
sudo -u postgres dropdb miniflux_backup_test
```

nixos-rebuild boot not switch this way once we reboot everything smooth

For video durations get API Key for: YouTube Data API v3
https://console.cloud.google.com/marketplace/product/google/youtube.googleapis.com
https://developers.google.com/youtube/v3

## Tailscale

login manually with tailscale up

## Scrutiny

InfluxDB2 Docs:
https://docs.influxdata.com/influxdb/v2/
Create scrutiny influxdb2 token:
influx auth create --description "scrutiny token" --read-orgs --org scrutiny --read-buckets --write-buckets --read-tasks --write-tasks --token $ADMIN_TOKEN
