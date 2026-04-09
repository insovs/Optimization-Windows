# Optimization-Windows / Network
A collection of network tweaks focused on reducing latency, stabilizing ping, and improving overall network responsiveness.

---

## Files

| File | Type | What it does |
|---|---|---|
| `ApplyCloudfllareDNS.bat` | .bat | Sets Cloudflare DNS (`1.1.1.1` / `1.0.0.1`) on all active network interfaces and flushes the DNS cache. |
| `Disable-NetworkPowerSaving.bat` | .bat | Disables all power saving features on all network adapters (EEE, Green Ethernet, Auto Disable Gigabit, Flow Control, etc.). Prevents latency spikes caused by the adapter throttling itself to save power. |
| `MSI Mode + High Priority Network Adapter.bat` | .bat | Enables MSI (Message Signaled Interrupts) on all PCI network adapters and sets interrupt priority to high (`DevicePriority=3`). |
| `NetworkThrottlingIndex.reg` | .reg | Sets `NetworkThrottlingIndex=0xFFFFFFFF` — disables Windows multimedia network throttling, preventing the OS from artificially limiting network throughput for non-multimedia apps. |
| `TCP AckFrequency, NoDelay, DalAckTicks Latency Optimization.bat` | .bat | Applies 3 TCP registry tweaks per adapter to minimize latency. See detail below. |

### Sub-folders

| Folder | What it contains |
|---|---|
| `Auto Tuning Level` | Scripts to enable / disable TCP receive window auto-tuning. |
| `Network Tweaker` | Additional network registry tweaks. |
| `WiFi` | Scripts to fully disable or re-enable WiFi — see detail below. |

---

## TCP Latency Optimization — detail

Applies the following registry keys to `HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{GUID}` for the selected adapter (or all adapters):

| Key | Value | Effect |
|---|---|---|
| `TcpAckFrequency` | `1` | Forces immediate ACK transmission — disables delayed ACK batching. |
| `TCPNoDelay` | `1` | Disables Nagle's algorithm — packets are sent immediately, not buffered. |
| `TcpDelAckTicks` | `0` | Sets ACK delay to minimum (0ms). |

The script lists all detected network adapters, lets you pick one or apply to all, then automatically restarts the adapter(s) to apply changes.

---

## MSI Mode

By default, network adapters use legacy INTx interrupts shared across devices. Enabling MSI gives the adapter a dedicated interrupt line, reducing CPU latency and contention during high-frequency network events (gaming, low-latency trading, real-time apps).

Changes applied per PCI network adapter:
- `MSISupported = 1` — enables Message Signaled Interrupts.
- `DevicePriority = 3` — sets interrupt handling to high priority.

Visible in **MSI Util v3** after applying.

---

## Cloudflare DNS

Replaces your current DNS servers with Cloudflare's on every active interface:

| | Address |
|---|---|
| Primary | `1.1.1.1` |
| Secondary | `1.0.0.1` |

Benefits: faster DNS resolution, privacy-respecting, built-in malware blocking. DNS cache is flushed automatically after applying.

---

## WiFi — what it does

| File | What it does |
|---|---|
| `DisableWiFi.bat` | Stops and disables all WiFi services, scheduled tasks, and PnP adapters. |
| `EnableWiFi.bat` | Restores all WiFi services, scheduled tasks, and adapters back to their default state. |

**DisableWiFi.bat** targets:

| Category | Targets |
|---|---|
| Services | `WlanSvc`, `vwififlt`, `Wcmsvc` |
| Scheduled tasks | `WiFiTask`, `CDSSync`, `MoProfileManagement`, `NotificationTask`, `OobeDiscovery` |
| Adapters | All PnP WiFi adapters disabled via PowerShell |

Only use if you are on a permanent wired Ethernet connection. Use `EnableWiFi.bat` to revert at any time. Run via `PowerRun.exe` as Administrator. Restart recommended after applying.

---

## Usage

1. Run as **Administrator** (right-click → Run as administrator).
2. `.reg` files: double-click or `regedit /s file.reg` as admin.
3. WiFi scripts must be run via `PowerRun.exe` for full service and adapter access.
