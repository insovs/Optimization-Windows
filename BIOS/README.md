# 🔧 Optimisation BIOS via SceWin
![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D4?style=flat-square&logo=windows)

> Accédez et modifiez les options **cachées** de votre BIOS directement depuis Windows, sans redémarrage.

---

> [!WARNING]
> **Modifier les paramètres BIOS incorrectement peut rendre votre système instable ou impossible à démarrer.**
> Créez toujours une sauvegarde de vos réglages actuels avant toute modification. Procédez avec précaution.

---

## ⚡ Réglages recommandés pour l'optimisation des performances

Ces 5 paramètres sont à désactiver dans le fichier `nvram.txt` pour réduire la latence et gagner en réactivité système.

| # | Nom du réglage | Valeur cible | Pourquoi ? |
|---|---|---|---|
| 1 | `AMD Cool&Quiet function` | `[00] Disabled` | Désactive la gestion automatique de fréquence CPU — maintient le CPU à sa fréquence maximale en permanence. |
| 2 | `Global C-state Control` | `[00] Disabled` | Empêche le CPU d'entrer en états de veille profonde (C1, C6…) — élimine les micro-latences au réveil. |
| 3 | `Power Supply Idle Control` | `[02] Typical Current Idle` | Réduit les variations de tension lors des transitions de charge — stabilise les performances. |
| 4 | `CPPC` *(Collaborative Processor Performance Control)* | `[00] Disabled` | Désactive la gestion dynamique des performances pilotée par l'OS — comportement plus prévisible et constant. |
| 5 | `CPPC Preferred Cores` | `[00] Disabled` | Empêche Windows de favoriser certains cœurs CPU — charge répartie uniforme sur tous les cœurs. |

> [!NOTE]
> Ces réglages sont orientés **performance brute et latence minimale** — idéal pour le gaming ou les workstations. Sur un usage bureautique classique, laisser ces options activées économise de l'énergie et réduit la chaleur.

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

Utilisez `Ctrl+F` pour rechercher le nom du réglage à modifier (ex: `Cool&Quiet`, `C-state`, `CPPC`…).

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
