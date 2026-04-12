# CursorUpdateInterval

Tweaks the Windows registry value that controls how often the cursor position is updated. This improve mouse responsiveness and reduce input latency.

> [!IMPORTANT]
> **This tweak can cause issues on some systems. Test before keeping it.**

## Files
| File | Description |
|---|---|
| `CursorUpdateInterval 0 (better).reg` | Sets interval to 0 — maximum update rate |
| `CursorUpdateInterval 1.reg` | Sets interval to 1 — slightly reduced rate |
| `revert-values (windows default).bat` | Restores Windows default values |

If anything feels off, run `revert-values (windows default).bat`

## Which value to choose?
- Start with **CursorUpdateInterval 1** to test stability
- If stable, try **CursorUpdateInterval 0** for improve responsiveness.

## Author
Made by [inso.vs](https://guns.lol/inso.vs)
