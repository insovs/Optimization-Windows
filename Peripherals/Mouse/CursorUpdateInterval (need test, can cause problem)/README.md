---

# CursorUpdateInterval

Tweaks the Windows registry value that controls how often the cursor position is updated. This improves mouse responsiveness and reduces input latency.

> [!IMPORTANT]
> **This tweak can cause issues on some systems. Test before keeping it.**

## Files
| File | Description |
|---|---|
| `CursorUpdateInterval 0 (better).reg` | Sets interval to 0 — maximum update rate |
| `CursorUpdateInterval 1.reg` | Sets interval to 1 — slightly reduced rate |
| `revert-values (windows default).bat` | Restores Windows default values |

If anything feels off, test a lower value between **0 and 5**, or run `revert-values (windows default).bat`.

## Which value to choose?
- Start with **CursorUpdateInterval 0** to test stability
- If unstable, try **CursorUpdateInterval 1** /2 etc

---
