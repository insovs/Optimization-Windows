# Optimization-Windows / Windows Security

Scripts to disable Windows Defender and related security services.

> ⚠ **Warning:** These scripts significantly reduce system security.

---

## Files

| File | Type | What it does |
|---|---|---|
| `Disable Defender.bat` | .bat | Fully disables Windows Defender — services, tamper protection, policies, real-time protection, notifications, SpyNet and scheduled tasks. |
| `Disable Mitigations.bat` | .bat | Disables CPU/memory mitigations (Spectre, Meltdown…) via registry — reduces latency at the cost of hardware-level security. |
| `Disable SmartScreen.reg` | .reg | Disables Windows SmartScreen — the filter that warns/blocks unknown executables and URLs. |
| `DisableHVCI.reg` | .reg | Disables HVCI (Hypervisor-Protected Code Integrity) — driver isolation enforced by the hypervisor. Improves compatibility and reduces overhead. |
| `DisableVBS.reg` | .reg | Disables VBS (Virtualization-Based Security) — isolates critical memory regions using Hyper-V. |

---

## Disable Defender.bat — steps

| Step | Action |
|---|---|
| [1/6] Services | Sets `Start=4` (disabled) on all Defender core services: `WinDefend`, `WdFilter`, `WdBoot`, `WdNisSvc`, `SecurityHealthService`, `Sense`… |
| [2/6] Tamper Protection | Prevents Defender from re-enabling itself (`TamperProtection=4`). |
| [3/6] Policies | Pushes local GPO keys: `DisableAntiSpyware`, `DisableRoutinelyTakingAction`, `ServiceKeepAlive=0`. |
| [4/6] Real-Time Protection | Disables behavior monitoring, on-access scanning, download scanning and real-time monitoring. |
| [5/6] Notifications | Suppresses all Defender, toast and Security Center notifications (HKLM + HKCU). |
| [6/6] SpyNet & Tasks | Cuts cloud reporting, ignores all detected threats, disables the 4 Defender s
