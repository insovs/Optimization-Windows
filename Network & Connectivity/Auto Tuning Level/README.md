# Network & Connectivity / Auto Tuning Level

Controls Windows TCP Auto Tuning — a feature that dynamically adjusts the TCP receive window size to optimize throughput.

---

| File | What it does |
|---|---|
| `DisableAutoTuningLevel.bat` | Sets TCP auto tuning to `disabled` via `netsh`. |
| `EnableAutoTuningLevel.bat` | Restores TCP auto tuning to `normal` (Windows default). |

---

## Which one should I use?

**Disable** — if you prioritize stable ping and low network latency (gaming, real-time apps, remote desktop).
TCP stops dynamically resizing its receive window, which stabilizes latency at the cost of raw download throughput. Expect a significant drop in download speeds on high-bandwidth connections.

**Enable (normal)** — for standard everyday use (browsing, streaming, downloading).
Windows automatically adjusts the TCP window to maximize throughput. This is the default and the right choice if latency is not a concern.

---

## Usage

1. Run as **Administrator** (right-click → Run as administrator).

> To check current state: `netsh interface tcp show global`

---
