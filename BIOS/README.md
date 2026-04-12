# 🔧 Optimisation BIOS via SceWin

![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D4?style=flat-square&logo=windows)
![BIOS](https://img.shields.io/badge/BIOS-AMI%20UEFI-green?style=flat-square)
![Version](https://img.shields.io/badge/SceWin-5.05.01-orange?style=flat-square)

> Accédez et modifiez les options **cachées** de votre BIOS directement depuis Windows, sans redémarrage.

---

> [!WARNING]
> **Modifier les paramètres BIOS incorrectement peut rendre votre système instable ou impossible à démarrer.**
> Créez toujours une sauvegarde de vos réglages actuels avant toute modification. Procédez avec précaution.

---

## ⚡ Réglages recommandés pour l'optimisation des performances

Ces paramètres sont à désactiver dans le fichier `nvram.txt` pour réduire la latence et gagner en réactivité système.

| # | Nom du réglage | Valeur cible | Pourquoi ? |
|---|---|---|---|
| 1 | `AMD Cool&Quiet function` | `[00] Disabled` | Désactive la gestion dynamique de fréquence CPU d'AMD — maintient le processeur à sa fréquence maximale en permanence et supprime les micro-variations de performances liées aux changements de P-State. |
| 2 | `Global C-state Control` | `[00] Disabled` | Empêche le CPU d'entrer en états de veille profonde (C1, C6…) — élimine les micro-latences dues au réveil du processeur lors d'un pic de charge soudain. |
| 3 | `DF C-states` | `[00] Disabled` | L'Infinity Fabric (bus interne AMD reliant le CPU, la mémoire et les cœurs) n'entre plus en basse fréquence au repos — supprime les micro-pics de latence lors des reprises d'activité. |
| 4 | `Power Down Enable` | `[00] Disabled` | Désactive la mise en veille des banques mémoire inutilisées — réduit la latence RAM et améliore la cohérence des frametimes. |
| 5 | `Power Supply Idle Control` | `[02] Typical Current Idle` | Réduit les variations de tension lors des transitions de charge — stabilise les performances et les frametimes. |
| 6 | `ECO Mode` | `[00] Disabled` | Lève la limite de TDP imposée au CPU — laisse le processeur atteindre ses fréquences boost maximales sans restriction de puissance. |
| 7 | `Bluetooth Controller` | `[00] Disabled` | Désactive le contrôleur Bluetooth intégré — supprime les interruptions et le polling périodique du périphérique, libère des ressources IRQ. À désactiver uniquement si vous n'utilisez pas le Bluetooth. |

> [!NOTE]
> Ces réglages sont orientés **performance brute et latence minimale** — idéal pour le gaming ou les workstations. Sur un usage bureautique classique, vous pouvez laisser ces options activées : elles économisent de l'énergie et réduisent la chaleur.

---

## 🔬 Réglages avancés — pour aller plus loin

> [!CAUTION]
> Ces réglages sont plus techniques et leur impact varie selon la carte mère, le CPU et la génération (AM4/AM5). Certains peuvent provoquer une instabilité si votre système est borderline en thermals ou en tension. **Appliquez-les un par un**, redémarrez entre chaque, et vérifiez la stabilité avant de continuer.

| # | Nom du réglage | Valeur cible | Impact | Notes |
|---|---|---|---|---|
| 1 | `TSME` *(Transparent Secure Memory Encryption)* | `[00] Disabled` | ✅ Sûr | Chiffrement transparent de la RAM — désactivé, il retire **5 à 7 ns de latence mémoire** ajoutée. Aucun impact sécurité sur un PC personnel non partagé. |
| 2 | `IOMMU` | `[00] Disabled` | ✅ Sûr | Unité de gestion mémoire pour les périphériques DMA — inutile sans virtualisation (VM, WSL2). Sa désactivation réduit les interruptions parasites. |
| 3 | `SR-IOV Support` | `[00] Disabled` | ✅ Sûr | Permet à un périphérique PCIe (GPU, carte réseau…) d'être partagé entre plusieurs machines virtuelles. Sans hyperviseur, c'est inutile. Cohérent avec la désactivation de l'IOMMU. |
| 4 | `Chipset Power Saving Features` | `[00] Disabled` | ✅ Sûr | Désactive la gestion d'énergie du chipset (ASPM, liens PCIe en L1…) — gain marginal sur la latence des communications CPU ↔ chipset. Sans risque d'instabilité notable. |
| 5 | `Data Scramble` | `[00] Disabled` | ⚠️ Tester | Brouillage des données mémoire pour réduire les interférences électromagnétiques (EMI). Peut améliorer la latence RAM mais peut causer une instabilité avec XMP/EXPO activé sur certains kits. Tester avec soin. |
| 6 | `APBDIS` | `[01]` (valeur `1`) | ⚠️ Tester | Force le P-State 0 de l'Infinity Fabric en permanence — fréquence IF fixe, zéro transition. Gain de cohérence sur les accès mémoire. Pas présent sur tous les BIOS. |

### 🟡 Cas particulier — Spread Spectrum

> [!WARNING]
> **Ne désactivez pas le Spread Spectrum sans raison valable.** Contrairement à ce que beaucoup de guides affirment, ce réglage ne réduit pas la latence gaming sur un système stock. Le Spread Spectrum module légèrement la fréquence d'horloge pour réduire les interférences électromagnétiques (EMI) — le désactiver peut au contraire **augmenter les EMI**, dégrader l'intégrité du signal et rendre le système moins stable.
>
> **La seule situation où le désactiver est utile :** vous faites un overclocking manuel du BCLK et vous voulez verrouiller votre fréquence de base à exactement 100.00 MHz. Sur un système sans OC BCLK, laissez-le tel quel.

| Réglage | Recommandation |
|---|---|
| `Spread Spectrum Control` | ⛔ Ne pas toucher sauf OC BCLK manuel |
| `PCIe Spread Spectrum` | ⛔ Ne pas toucher sauf OC BCLK manuel |

---

## 🪜 Procédure complète — étape par étape

**Vue d'ensemble rapide :** `SCEWIN_FIX.reg` → `Export.bat` → modifier `nvram.txt` → `Import.bat`

---

### 1️⃣ Appliquer la clé de registre

Double-cliquez sur **`SCEWIN_FIX.reg`** et confirmez l'ajout au registre Windows.

> ⚠ Cette étape est **obligatoire en premier**. Sans elle, SceWin ne peut pas accéder au BIOS.

---

### 2️⃣ Exporter les paramètres BIOS actuels

Faites un **clic droit** sur `Export.bat` → **Exécuter en tant qu'administrateur**.

Un fichier **`nvram.txt`** sera créé dans le même dossier — il contient tous les réglages BIOS de votre machine.

> 💡 **Avant de toucher quoi que ce soit**, faites une copie du fichier et renommez-la `nvram_backup.txt`. C'est votre filet de sécurité.

---

### 3️⃣ Modifier le fichier nvram.txt

Ouvrez `nvram.txt` avec un éditeur de texte (Notepad, VS Code, Notepad++…).

Utilisez `Ctrl+F` pour rechercher le nom du réglage à modifier (ex : `Cool&Quiet`, `C-state`, `ECO Mode`…).

**La règle est simple : le `*` indique l'option active. Déplacez-le sur la valeur souhaitée, c'est tout.**

Chaque entrée dans le fichier ressemble à ceci :

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

Dans cet exemple, le `*` est déjà sur `[00]Disabled` → Cool&Quiet est **désactivé** ✅ c'est la valeur qu'on veut.

Si au contraire le `*` était sur `[01]Enabled` comme ici :

```
Options	=[00]Disabled	// Move "*" to the desired Option
         *[01]Enabled
```

Il faudrait le déplacer pour obtenir :

```
Options	=*[00]Disabled	// Move "*" to the desired Option
         [01]Enabled
```

> [!IMPORTANT]
> Ne modifiez **que la ligne `Options`**. Les champs `Token`, `Offset`, `Width` ne doivent **jamais** être changés.
> Il doit toujours y avoir **un seul `*`** par bloc `Options`. Ni zéro, ni deux.

---

### 4️⃣ Importer les modifications dans le BIOS

Faites un **clic droit** sur `Import.bat` → **Exécuter en tant qu'administrateur**.

Les modifications sont appliquées directement au BIOS. Un **redémarrage** peut être nécessaire pour que certains changements prennent effet.

> ✅ Si l'import se termine sans message d'erreur, vos réglages sont bien appliqués.

---

## 📁 Contenu du dépôt

| Fichier | Rôle |
|---|---|
| `SCEWIN_FIX.reg` | ⭐ **À exécuter en premier.** Clé de registre qui permet à SceWin de fonctionner correctement sur les systèmes récents. |
| `SCEWIN_64.exe` | Outil principal pour lire et écrire les paramètres NVRAM du BIOS. |
| `Export.bat` | Exporte tous les paramètres BIOS actuels dans un fichier `nvram.txt`. |
| `Import.bat` | Applique les modifications du fichier `nvram.txt` au BIOS. |
| `amiflldrv64.sys` / `amigendrv64.sys` | Drivers nécessaires au fonctionnement de SceWin. |

---

## ✅ Prérequis

- Windows 10 ou 11 (64 bits)
- Droits **administrateur**
- Carte mère compatible **AMI BIOS (UEFI)**
- Désactiver temporairement l'antivirus si SceWin est bloqué (faux positif fréquent)

---

## 🛡 Restauration en cas de problème

Si votre système devient instable après modification :

1. Relancez `Export.bat` pour vérifier l'état actuel
2. Ouvrez votre **sauvegarde** `nvram_backup.txt`
3. Copiez les valeurs d'origine dans `nvram.txt`
4. Relancez `Import.bat` en administrateur

En dernier recours, un reset BIOS (jumper sur la carte mère ou retrait de la pile CMOS) restaure les valeurs d'usine.

---

## ⚠ Avertissement légal

Ce projet utilise **SceWin**, un outil tiers développé indépendamment.
L'auteur de ce dépôt n'est pas affilié aux fabricants de cartes mères ni à AMI.
Toute modification est effectuée **à vos risques et périls**.
