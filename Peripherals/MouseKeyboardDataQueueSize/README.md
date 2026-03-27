# MouseDataQueueSize Optimization — [guns.lol/inso.vs](https://guns.lol/inso.vs)

Controls the input buffer size for mouse and keyboard processing in Windows.
Lower = less latency. Too low = missed inputs, jumps, glitches.

## How to Tune

1. Start at `18` decimal, apply the provided `.reg` file and reboot.
2. Test in-game and under load for at least 15–20 min per value.
3. If stable → lower by 1–2 and repeat. If unstable → raise by 1–2 and repeat.
4. Target: lowest stable value. Once issues appear, go back up 1–2 units.

**Signs of too low:** missed clicks, input jumps, stuttering, ghosting.
**Signs of stable:** smooth and responsive under all loads, no glitches.

> Always backup your registry before making changes. Reboot after every edit.
