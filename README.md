# Debian 13 Industrial Chromium Kiosk

This role configures a simple Xorg/Openbox Chromium kiosk:

- tty1 automatic login as `kiosk`
- Xorg started with `startx`
- Openbox session
- Chromium in kiosk/fullscreen mode
- multiple configured URLs
- automatic Ctrl+Tab rotation
- Chromium restart loop
- local watchdog with automatic reboot
- optional persistent Chromium profile
- optional overlayroot read-only root filesystem

## Important: persistent disk

If `kiosk_persistent_data_enabled: true`, the target must already have a
filesystem available at `kiosk_persistent_device`.

Example:

```bash
mkfs.ext4 /dev/sdb2
e2label /dev/sdb2 KIOSKDATA
```

Then leave:

```yaml
kiosk_persistent_device: "/dev/disk/by-label/KIOSKDATA"
```

The role mounts it at `/var/lib/kiosk` and stores the Chromium profile at:

`/var/lib/kiosk/chromium`

## Install dependencies

```bash
ansible-galaxy collection install -r requirements.yml
```

## Test connectivity

```bash
ansible -i inventory.ini kiosk -m ping
```

## Deploy normally

```bash
ansible-playbook site.yml
```

Do this first. Overlay is intentionally NOT enabled by the normal run.

## Health check

```bash
ansible-playbook healthcheck.yml
```

## Enable read-only overlay

Only after the normal installation and persistent storage are working:

```bash
ansible-playbook site.yml -t overlay
```

The machine will reboot.

Check:

```bash
findmnt /
```

Expected filesystem type:

`overlay`

## Disable overlay before maintenance

```bash
ansible-playbook site.yml -t disable-overlay
```

Then perform package/configuration updates.

## Things this role deliberately does not do

- partition or format disks automatically
- configure Wi-Fi
- configure a static IP
- configure firewall rules
- provide true OS rollback
- enable hardware watchdog
- manage TLS certificates
- manage application-specific Chromium policies

Those should be added only when the target hardware/network requirements are known.
