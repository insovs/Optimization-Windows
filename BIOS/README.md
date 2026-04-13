# 🔧 BIOS Optimization via SceWin (AMD & INTEL)

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
| 1 | `Spread Spectrum` | `Disabled` | Slightly modulates the clock frequency to reduce electromagnetic interference (EMI) — disabling it stabilizes the clock frequency and can reduce signal jitter on some configurations. |
| 2 | `AMD Cool&Quiet function` | `Disabled` | Disables AMD's dynamic CPU frequency management — keeps the processor at its maximum frequency at all times and eliminates micro-variations in performance caused by P-State transitions. |
| 3 | `Global C-state Control` | `isabled` | Prevents the CPU from entering deep sleep states (C1, C6…) — eliminates micro-latencies caused by the processor waking up during sudden load spikes. |
| 4 | `DF C-states` | `Disabled` | Keeps the Infinity Fabric (AMD's internal bus connecting the CPU, memory, and cores) out of low-frequency idle mode — removes micro-latency spikes when activity resumes. |
| 5 | `Power Down Enable` | `[Disabled` | Disables sleep mode for unused memory banks — reduces RAM latency and improves frametime consistency. |
| 6 | `Power Supply Idle Control` | `Typical Current Idle` | Reduces voltage fluctuations during load transitions — stabilizes performance and frametimes. |
| 7 | `ECO Mode` | `Disabled` | Lifts the TDP limit imposed on the CPU — allows the processor to reach its maximum boost frequencies without power restrictions. |
| 8 | `Bluetooth Controller` | `Disabled` | Disables the onboard Bluetooth controller — removes periodic device polling and interrupts, freeing IRQ resources. Only disable if you don't use Bluetooth. |

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

> [!TIP]
> **New to this?** Watch [@Ancel's video](https://www.youtube.com/watch?v=jRsaGmptP0E&t=91s) first — it walks through the full procedure with the tool.

---

### 1️⃣ Apply the registry key

> [!CAUTION]
> **Do this before anything else.** Without it, SceWin cannot access the BIOS.

**Double-click `SCEWIN_FIX.reg`** and confirm when Windows asks you to add it to the registry.

---

### 2️⃣ Export your current BIOS settings

**Right-click `Export.bat`** → **Run as administrator**.

This generates a **`nvram.txt`** file in the same folder containing every BIOS setting on your machine.

> [!IMPORTANT]
> **Immediately make a backup:** copy `nvram.txt` and rename it `nvram_backup.txt` before editing anything.
> If something goes wrong, this file is how you get back to your original state.

---

### 3️⃣ Edit nvram.txt

Open `nvram.txt` with any text editor (Notepad, VS Code, Notepad++…) and use `Ctrl+F` to find the setting you want to change.

**How it works — one simple rule: the `*` = the currently active option. Move it, nothing else.**

Each setting block looks like this:

```
Setup Question  = AMD Cool&Quiet function
Help String     = Enable/Disable AMD Cool&Quiet function.
Token           =27    // Do NOT change this line
Offset          =14A
Width           =01
BIOS Default    =[01]Enabled
Options         =*[00]Disabled    // Move "*" to the desired Option
                 [01]Enabled
```

Here the `*` is on `[00]Disabled` → Cool&Quiet is **already disabled** ✅

If the `*` is on the wrong option, simply move it:

```
// ❌ Before — setting is Enabled
Options  =[00]Disabled    // Move "*" to the desired Option
          *[01]Enabled

// ✅ After — setting is now Disabled
Options  =*[00]Disabled   // Move "*" to the desired Option
          [01]Enabled
```


---

### 4️⃣ Import the changes into the BIOS

**Right-click `Import.bat`** → **Run as administrator**.

SceWin writes the changes directly to your BIOS. **Reboot** your PC afterward for all changes to take effect.

> ✅ No error message = everything applied correctly.
> Minor warnings during import are generally harmless — as long as you followed the steps above carefully.

---

## 📁 Repository Contents

| File | Role |
|---|---|
| `SCEWIN_FIX.reg` | ⭐ **Run this first.** Registry key that allows SceWin to function correctly on recent systems. |
| `SCEWIN_64.exe` | Main tool for reading and writing BIOS NVRAM parameters. |
| `Export.bat` | Exports all current BIOS settings to a `nvram.txt` file. |
| `Import.bat` | Applies the changes from `nvram.txt` to the BIOS. |
| `amiflldrv64.sys` / `amigendrv64.sys` | Drivers required for SceWin to operate. |
| `Advanced Users/BIOS Settings Guide.pdf` | Full reference documentation — covers all visible and hidden AMD BIOS settings in detail, including advanced options beyond this README. |

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
