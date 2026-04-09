# Xbox

All Xbox-related background services.
Safe to disable if you do not use Xbox Game Pass, Xbox Live, or Xbox accessories.

> [!NOTE]
> If you use **Xbox Game Pass** or **Xbox Live**, do not apply any of these.

| File | What it disables | Watch out |
|------|-----------------|-----------|
| `Disable-XboxServices.reg` | Xbox background services bundle | Skip if you use Xbox Game Pass |
| `Disable-XboxLiveAuthManager.reg` | Xbox Live login service | Skip if you use Xbox Game Pass or Xbox Live |
| `Disable-XboxLiveGameSave.reg` | Xbox cloud save sync | Skip if you rely on Xbox cloud saves |
| `Disable-XboxAccessoryManagement.reg` | Xbox wired accessory driver | Skip if you use a wired Xbox controller |
