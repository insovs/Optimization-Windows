# Network & Legacy

Old or rarely useful network services. Most of these are leftovers from older Windows versions.

| File | What it disables | Watch out |
|------|-----------------|-----------|
| `Disable-IPHelper.reg` | IPv6 tunneling (Teredo, 6to4) | Skip if your VPN uses IPv6 |
| `Disable-TCPNetBIOSHelper.reg` | Very old Windows network protocol | — |
| `Disable-DistributedLinkTracking.reg` | Tracks file shortcuts across network drives | — |
| `Disable-FunctionDiscoveryPublication.reg` | Makes your PC visible to others on local network | Skip if you share files between PCs |
| `Disable-RemoteRegistry.reg` | Remote access to your registry | — |
| `Disable-MapsBroker.reg` | Windows Maps offline sync | — |
| `Disable-OfflineFiles.reg` | Syncs network folders for offline use | Skip if you work with network drives |
