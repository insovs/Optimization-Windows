# Windows Update Blocker (WUB)

**Windows Update Blocker** is a portable tool that lets you disable or re-enable Windows Updates with a single click — preventing unwanted changes, slowdowns, or forced restarts.

<details>
<summary>▶ Show Utility</summary>
<br>
<img width="422" height="207" alt="image" src="https://github.com/user-attachments/assets/bb07bf3b-1303-4a03-936e-c0bfea330df2" />
</details>

---

## 🚀 Features
* ✅ Works on Windows 10 & 11
* ✅ One-click disable/enable Windows Updates
* ✅ Prevents Windows from automatically re-enabling updates
* ✅ Lightweight and portable (no installation required)

---

## 🛠️ How to Use

**Disable Windows Updates**
1. Run `Wub.exe` as Administrator
2. Select "Disable Updates"
3. Click "Apply Now"

**Re-enable Windows Updates**
1. Select "Enable Updates"
2. Click "Apply Now"

**Advanced Settings**
* Click "Menu" > Service List to see which Windows services are affected.
* You can modify `Wub.ini` for additional configurations.

---

## ❗ Important Notes
* Some third-party applications or Windows Defender may try to re-enable updates.
* Windows Feature Updates may reset WUB settings — reapply if needed.
* `UsoSvc` is set to **Manual** instead of Disabled — Windows actively fights against disabling it, Manual is more stable.

---

## 💡 Disclaimer
This tool is for educational purposes only. Use at your own risk. Disabling updates may leave your system vulnerable to security threats.

---

*Original tool by [sordum.org](https://www.sordum.org)*
