# CursorUpdateInterval

Tweaks the Windows registry value that controls how often the cursor position is updated — can improve mouse responsiveness and reduce input latency.

> ⚠️ **This tweak can cause issues on some systems. Test before keeping it.**

## Files
| File | Description |
|---|---|
| `CursorUpdateInterval 0 (better).reg` | Sets interval to 0 — maximum update rate |
| `CursorUpdateInterval 1.reg` | Sets interval to 1 — slightly reduced rate |
| `revert-values (windows default).bat` | Restores Windows default values |
| `if u have problem.md` | Troubleshooting steps if issues occur |

## Usage
1. Pick either `.reg` file and double-click it
2. Accept the UAC prompt
3. **Reboot** to apply changes
4. If anything feels off, run `revert-values (windows default).bat`

## Which value to choose?
- Start with **CursorUpdateInterval 1** to test stability
- If stable, try **CursorUpdateInterval 0** for maximum effect

## Reverting
Run `revert-values (windows default).bat` as administrator, then reboot.

## Author
Made by [inso.vs](https://guns.lol/inso.vs)
