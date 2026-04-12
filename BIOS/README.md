# 🔧 BIOS Optimization via SceWin

![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D4?style=flat-square&logo=windows)
![BIOS](https://img.shields.io/badge/BIOS-AMI%20UEFI-green?style=flat-square)
![Version](https://img.shields.io/badge/SceWin-5.05.01-orange?style=flat-square)

> Access and modify your BIOS settings — including hidden ones — directly from Windows, without rebooting.

---

> [!WARNING]
> Always create a backup of your current settings before making any changes.
> **Incorrectly modifying BIOS parameters can make your system unstable or unbootable. This guide focuses on settings that are generally considered safe — however, if you choose to go further using the PDF documentation, you do so entirely at your own risk. No responsibility will be taken for any issues that may arise.**

---

## ⚡ Recommended Settings for Performance Optimization

These settings should be disabled in the `nvram.txt` file to reduce latency and improve system responsiveness.

| # | Setting Name | Target Value | Why? |
|---|---|---|---|
| 1 | `Spread Spectrum` | `[00] Disabled` | Slightly modulates the clock frequency to reduce electromagnetic interference (EMI) — disabling it stabilizes the clock frequency and can reduce signal jitter on some configurations. |
| 2 | `AMD Cool&Quiet function` | `[00] Disabled` | Disables AMD's dynamic CPU frequency management — keeps the processor at its maximum frequency at all times and eliminates micro-variations in performance caused by P-State transitions. |
| 3 | `Global C-state Control` | `[00] Disabled` | Prevents the CPU from entering deep sleep states (C1, C6…) — eliminates micro-latencies caused by the processor waking up during sudden load spikes. |
| 4 | `DF C-states` | `[00] Disabled` | Keeps the Infinity Fabric (AMD's internal bus connecting the CPU, memory, and cores) out of low-frequency idle mode — removes micro-latency spikes when activity resumes. |
| 5 | `Power Down Enable` | `[00] Disabled` | Disables sleep mode for unused memory banks — reduces RAM latency and improves frametime consistency. |
| 6 | `Power Supply Idle Control` | `[02] Typical Current Idle` | Reduces voltage fluctuations during load transitions — stabilizes performance and frametimes. |
| 7 | `ECO Mode` | `[00] Disabled` | Lifts the TDP limit imposed on the CPU — allows the processor to reach its maximum boost frequencies without power restrictions. |
| 8 | `Bluetooth Controller` | `[00] Disabled` | Disables the onboard Bluetooth controller — removes periodic device polling and interrupts, freeing IRQ resources. Only disable if you don't use Bluetooth. |

> [!NOTE]
> These settings are oriented toward **raw performance and minimal latency** — ideal for gaming or workstations. For standard office use, leaving these options enabled saves energy and reduces heat.

---

## 🔬 Advanced Settings

> [!CAUTION]
> These settings are more technical and their impact varies depending on the motherboard, CPU, and generation (AM4/AM5). Some may cause instability if your system is borderline on thermals, voltage, or has an unstable overclock. **Apply them one at a time**, reboot between each change, and verify stability before continuing.

| # | Setting Name | Target Value | Impact | Notes |
|---|---|---|---|---|
| 1 | `SR-IOV Support` | `[00] Disabled` | ✅ Safe | Allows a PCIe device (GPU, network card…) to be shared between multiple virtual machines. Without a hypervisor, this is useless. |
| 2 | `Chipset Power Saving Features` | `[00] Disabled` | ✅ Safe | Disables chipset power management (ASPM, PCIe L1 links…) — marginal gain on CPU ↔ chipset communication latency. No notable stability risk. |
| 3 | `TSME` *(Transparent Secure Memory Encryption)* | `[00] Disabled` | ✅ Safe | Transparent RAM encryption — disabling it removes **5 to 7 ns of added memory latency**. No security impact on a personal, non-shared PC. |
| 4 | `Data Scramble` | `[00] Disabled` | ⚠️ Test first | Memory data scrambling used to reduce EMI. Can improve RAM latency but may cause instability with XMP/EXPO enabled on some kits. Test carefully. |
| 5 | `IOMMU` | `[00] Disabled` | ⚠️ Test first | Memory management unit for DMA devices — unnecessary without virtualization (VM, WSL2). Disabling it reduces parasitic interrupts, but may cause issues on some configurations. |

---

## 🪜 Step-by-Step Procedure

> A video [here](https://www.youtube.com/watch?v=jRsaGmptP0E&t=91s) by [@Ancel](https://github.com/ancel1x) is available presenting the tool (SceWin) and walking through the full procedure.

---

### 1️⃣ Apply the registry key

Double-click **`SCEWIN_FIX.reg`** and confirm adding it to the Windows registry.

> ⚠ This step is **mandatory first**. Without it, SceWin cannot access the BIOS.

---

### 2️⃣ Export current BIOS settings

**Right-click** `Export.bat` → **Run as administrator**.

A **`nvram.txt`** file will be created in the same folder — it contains all your machine's current BIOS settings.

> 💡 **Before touching anything**, make a copy of the file and rename it `nvram_backup.txt`. This is your safety net.

---

### 3️⃣ Edit the nvram.txt file

Open `nvram.txt` with a text editor (Notepad, VS Code, Notepad++…).

Use `Ctrl+F` to search for the setting name you want to change (e.g. `Cool&Quiet`, `C-state`, `ECO Mode`…).

**The rule is simple: the `*` marks the active option. Move it to the desired value, that's it.**

Each entry in the file looks like this:

```
Setup Question	= AMD Cool&Quiet function
Help String	= Enable/Disable AMD Cool&Quiet function.
Token	=27	// Do NOT change this line
Offset	=14A
Width	=01
BIOS Default	=[01]Enabled
Options	=*[00]Disabled	// Move "*" to the desired Option
         [01]Enabled
```

In this example, the `*` is already on `[00]Disabled` → Cool&Quiet is **disabled** ✅ which is what we want.

If instead the `*` was on `[01]Enabled` like this:

```
Options	=[00]Disabled	// Move "*" to the desired Option
         *[01]Enabled
```

You would move it to get:

```
Options	=*[00]Disabled	// Move "*" to the desired Option
         [01]Enabled
```

> [!IMPORTANT]
> Only modify the **`Options` line**. The `Token`, `Offset`, `Width`, etc. fields must **never** be changed!
> There must always be **exactly one `*`** per `Options` block. Not zero, not two.

---

### 4️⃣ Import the changes into the BIOS

**Right-click** `Import.bat` → **Run as administrator**.

Changes are applied directly to the BIOS. A **reboot** may be required for some changes to take effect.

> ✅ If the import completes without any error message, your settings have been applied successfully.
> Some minor warnings are not critical — if you followed the steps correctly and made no obvious mistakes, everything should be fine.

---

## 📁 Repository Contents

| File | Role |
|---|---|
| `SCEWIN_FIX.reg` | ⭐ **Run this first.** Registry key that allows SceWin to function correctly on recent systems. |
| `SCEWIN_64.exe` | Main tool for reading and writing BIOS NVRAM parameters. |
| `Export.bat` | Exports all current BIOS settings to a `nvram.txt` file. |
| `Import.bat` | Applies the changes from `nvram.txt` to the BIOS. |
| `amiflldrv64.sys` / `amigendrv64.sys` | Drivers required for SceWin to operate. |
| `AMD BIOS Settings Guide.pdf` | Full reference documentation by @insopti (remastered from @Ancel's original guide) — covers all visible and hidden AMD BIOS settings in detail, including advanced options beyond this README. |

---

## ✅ Prerequisites

- Windows 10 or 11 (64-bit)
- Motherboard with **AMI BIOS (UEFI)**
- Temporarily disable any antivirus if SceWin is blocked (common false positive)

---

## 🛡 Recovery in Case of Issues

If your system becomes unstable after a change:

1. Run `Export.bat` again to check the current state
2. Open your **backup** `nvram_backup.txt`
3. Copy the original values back into `nvram.txt`
4. Run `Import.bat` as administrator

As a last resort, a BIOS reset (motherboard jumper or removing the CMOS battery) restores factory defaults.

> 🔗 How to reset BIOS by removing the CMOS battery: https://www.youtube.com/watch?v=xey0us9Nyyo

---
