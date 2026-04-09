# Network Power Saving

Disables all power saving features on your network adapter that can cause
lag spikes, disconnections or reduced throughput — especially in gaming.

---

## What gets disabled

| Feature | Effect when enabled |
|---------|-------------------|
| Energy-Efficient Ethernet (EEE) | Reduces link speed to save power — causes latency spikes |
| Advanced EEE | Same as above, more aggressive version |
| Green Ethernet | Adjusts power based on cable length — can drop connection |
| Auto Disable Gigabit | Drops from 1Gbps to 100Mbps to save power |
| Flow Control | Can introduce artificial delays in packet flow |
| Gigabit Lite | Reduces power by capping speed |
| Power Management | Allows Windows to turn off the adapter to save power |

---

## Files

| File | What it does |
|------|-------------|
| `Disable-NetworkPowerSaving.bat` | Disables all of the above on every network adapter detected |

---

## How to use

1. Right-click `Disable-NetworkPowerSaving.bat`
2. Select **Run as administrator**
3. Confirm when prompted
4. Restart when done

---

> **Compatible with all network adapters** — works on Realtek, Intel, Killer, Broadcom and others.
> Settings that don't exist on your adapter are safely skipped.
