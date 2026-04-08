# Optimized Custom PowerPlan

Imports and activates a custom **PowerPlan** to maximize performance and minimize latency.

> [!NOTE]
> The Power Plan script has its own dedicated repository with more details: **[insopti-PowerPlan](https://github.com/insovs/insopti-PowerPlan)**

---

## Installation

Download `insopti-PowerPlan.ps1`, then **right-click** → **Run with PowerShell**.

The script will automatically request administrator privileges, then prompt you to select the profile suited to your CPU configuration.

> [!CAUTION]
> If PowerShell scripts are blocked on your system, enable execution first:
> ```powershell
> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```
> Or use **[EnablePowerShellScript](https://github.com/insovs/EnablePowerShellScript)** for a one-click solution.

---

## Plan Selection

| Option | Description |
|---|---|
| **`1` Static OC** | Fixed CPU frequency, Precision Boost disabled |
| **`2` Dynamic Boost** | Precision Boost / Turbo enabled *(recommended for most)* |

---

## What it does

| Optimization | Description |
|---|---|
| **PowerPlan Import** | Downloads and imports the `insopti` plan |
| **CPU no-throttle** | Disables frequency throttling and latency mitigation |
| **CPU Unparking** | Unlocks all CPU cores |
| **USB Power** | Reduces input delay |
| **Sleep States** | Configured for maximum responsiveness |

---

## Uninstall

Open **Control Panel → Power Options**, switch to a default Windows plan, and delete `insopti` from the list.

> [!NOTE]
> No permanent system files are modified — switching plans reverts everything.

---

<div align="center">
  <sub>©insopti — <a href="https://guns.lol/inso.vs">guns.lol/inso.vs</a> · For personal use only.</sub>
</div>
