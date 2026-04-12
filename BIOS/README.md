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

## 📁 Contenu du dépôt

| Fichier | Rôle |
|---|---|
| `SCEWIN_FIX.reg` | ⭐ **À exécuter en premier.** Clé de registre qui permet à SceWin de fonctionner correctement sur les systèmes récents. |
| `SCEWIN_64.exe` | Outil principal pour lire et écrire les paramètres NVRAM du BIOS. |
| `Export.bat` | Exporte tous les paramètres BIOS actuels dans un fichier `nvram.txt`. |
| `Import.bat` | Applique les modifications du fichier `nvram.txt` au BIOS. |
| `amiflldrv64.sys` / `amigendrv64.sys` | Drivers nécessaires au fonctionnement de SceWin. |

---

## 🪜 Procédure complète — étape par étape

### Étape 1 — Appliquer la clé de registre

Double-cliquez sur **`SCEWIN_FIX.reg`** et confirmez l'ajout au registre Windows.

> Cette étape est **obligatoire** avant tout le reste. Elle permet à SceWin de communiquer correctement avec le BIOS sur les systèmes Windows récents.

---

### Étape 2 — Exporter les paramètres BIOS actuels

Faites un **clic droit** sur `Export.bat` → **Exécuter en tant qu'administrateur**.

Un fichier **`nvram.txt`** sera créé dans le même dossier.  
Il contient l'intégralité des paramètres BIOS de votre machine.

> 💡 **Conseil :** Faites immédiatement une copie de ce fichier sous le nom `nvram_backup.txt` avant de le modifier — cela vous permettra de tout restaurer si besoin.

---

### Étape 3 — Modifier le fichier nvram.txt

Ouvrez `nvram.txt` avec un éditeur de texte (Notepad, VS Code, Notepad++…).

Chaque paramètre BIOS est listé avec toutes ses valeurs possibles.  
L'option **actuellement active** est indiquée par un astérisque **`*`** placé devant la valeur.

**Pour changer une option, déplacez simplement le `*` vers la ligne de la valeur souhaitée.**

Chaque entrée dans le fichier ressemble à ceci — voici un exemple réel :

```
Setup Question	= SVM Mode
Help String	= Enable/Disable CPU Virtualization.
Token	=29	// Do NOT change this line
Offset	=14C
Width	=01
BIOS Default	=[00]Disabled 
Options	=*[00]Disabled	// Move "*" to the desired Option
         [01]Enabled
```

Ici, le `*` est sur `[00]Disabled` → la virtualisation CPU est **désactivée**.

Pour l'**activer**, on déplace le `*` sur `[01]Enabled` :

```
Setup Question	= SVM Mode
Help String	= Enable/Disable CPU Virtualization.
Token	=29	// Do NOT change this line
Offset	=14C
Width	=01
BIOS Default	=[00]Disabled 
Options	=[00]Disabled	// Move "*" to the desired Option
         *[01]Enabled
```

> [!IMPORTANT]
> Ne modifiez **que la ligne `Options`**. Les champs `Token`, `Offset`, `Width` ne doivent jamais être changés.  
> Il doit toujours y avoir **un seul `*`** par bloc `Options`.

> 💡 Utilisez `Ctrl+F` pour rechercher un réglage par nom (ex: `SVM Mode`, `Cool&Quiet`, `NX Mode`, `Above 4G`).  
> Si vous débutez, ne modifiez **qu'un seul paramètre à la fois** pour identifier facilement la cause en cas de problème.

---

### Étape 4 — Importer les modifications

Faites un **clic droit** sur `Import.bat` → **Exécuter en tant qu'administrateur**.

Les modifications sont appliquées directement au BIOS.  
Un **redémarrage** peut être nécessaire pour que certains changements prennent effet.

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
