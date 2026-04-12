# CursorUpdateInterval

Tweaks the Windows registry value that controls how often the cursor position is updated. This improves mouse responsiveness and reduces input latency.

> [!IMPORTANT]
> **This tweak can cause issues on some systems. Test before keeping it.**
> If anything feels off, your mouse disconnects on its own or behaves erratically test a lower value between **0 and 5**, or run `revert-values (windows default).bat`.

## Files
| File | Description |
|---|---|
| `CursorUpdateInterval 0.reg` | Sets interval to 0 — maximum update rate |
| `CursorUpdateInterval 1.reg` | Sets interval to 1 — slightly reduced rate |
| `revert-values (windows default).bat` | Restores Windows default values |

## Which value to choose?
- Start with **CursorUpdateInterval 0**.
- If unstable, try **CursorUpdateInterval 1** or **2** etc.

---
