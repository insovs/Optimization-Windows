# User & Session

Services related to user accounts and session management.

| File | What it disables | Watch out |
|------|-----------------|-----------|
| `Disable-SecondaryLogon.reg` | "Run as different user" option | — |
| `Disable-ParentalControls.reg` | Parental controls enforcement | Skip if you have child accounts on this PC |
| `Disable-HomeGroupProvider.reg` | HomeGroup services (removed since Windows 10 1803, may still run) | — |
