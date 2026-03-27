# Mouse and Keyboard DataQueueSize Optimization

Controls the input buffer size for mouse and keyboard processing in Windows.
Lower = less latency. Too low = missed inputs, jumps, glitches.

## Recommended Starting Points

**Mouse:** Start at `16`. Stable for most setups — try to go lower if possible, but results vary per system.

**Keyboard:** Start at `16`. Much easier to reduce — most users can reach `4–6` without any issues.

## How to Tune

1. Apply the provided `.reg` file at the recommended value and reboot.
2. Test in-game and under load for at least 15–20 min per value.
3. If stable → lower by 1–2 and repeat. If unstable → raise by 1–2 and repeat.
4. Target: lowest stable value. Once issues appear, go back up 1–2 units.

**Signs of too low:** missed clicks, input jumps, stuttering, ghosting.
**Signs of stable:** smooth and responsive under all loads, no glitches.

> Reboot after every edit.
