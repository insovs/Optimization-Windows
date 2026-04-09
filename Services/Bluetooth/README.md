# Bluetooth

Scripts to fully disable or re-enable all Bluetooth services, adapters, drivers and radio on Windows.
More complete than a simple `.reg` tweak — this handles everything in one shot.

> [!NOTE]
> **Make sure you dont use Bluetooth before applying.**

---

## Files

| File | What it does |
|------|-------------|
| `Disable-Bluetooth.bat` | Stops and disables all Bluetooth services, adapters, radio and policies |
| `Enable-Bluetooth.bat` | Re-enables everything and restores Bluetooth to a working state |

---

## What gets disabled

- All Bluetooth background services (`bthserv`, `BTHPORT`, `BTHUSB`, `RFCOMM`, and more)
- Bluetooth PnP adapters
- Bluetooth radio
- Bluetooth system policy

---

## How to use

1. Right-click the `.bat` file
2. Select **Run as administrator**
3. Confirm when prompted
4. Restart when done
