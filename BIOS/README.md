# 🔧 Optimisation BIOS (via SceWin, methode facile et rapide)

![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D4?style=flat-square&logo=windows)
![BIOS](https://img.shields.io/badge/BIOS-AMI%20UEFI-green?style=flat-square)
![Version](https://img.shields.io/badge/SceWin-5.05.01-orange?style=flat-square)

> Accédez et modifiez les options de votre BIOS ainsi que ceux  **cachées** directement depuis Windows, tres facilement et rapidement.

---

> [!WARNING]
> **Modifier les paramètres BIOS incorrectement peut rendre votre système instable ou impossible à démarrer.**
> Créez toujours une sauvegarde de vos réglages actuels avant toute modification. Procédez avec précaution.

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

**Pour changer une option, déplacez simplement le `*` vers la valeur souhaitée.**

#### Exemple :

```
Setup Question  : Hyper Threading
  Options       : *Disabled     ← option actuellement active
                   Enabled
```

Pour activer le Hyper Threading, modifiez comme ceci :

```
Setup Question  : Hyper Threading
  Options       :  Disabled
                  *Enabled      ← le * indique le nouveau choix
```

> 💡 Utilisez `Ctrl+F` pour rechercher un réglage par nom (ex: `"Hyper Threading"`, `"C-States"`, `"Above 4G Decoding"`).  
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

## 📁 Contenu du dépôt

| Fichier | Rôle |
|---|---|
| `SCEWIN_FIX.reg` | ⭐ **À exécuter en premier.** Clé de registre qui permet à SceWin de fonctionner correctement sur les systèmes récents. |
| `SCEWIN_64.exe` | Outil principal pour lire et écrire les paramètres NVRAM du BIOS. |
| `Export.bat` | Exporte tous les paramètres BIOS actuels dans un fichier `nvram.txt`. |
| `Import.bat` | Applique les modifications du fichier `nvram.txt` au BIOS. |
| `amiflldrv64.sys` / `amigendrv64.sys` | Drivers nécessaires au fonctionnement de SceWin. |

---

## ⚠ Avertissement légal

Ce projet utilise **SceWin**, un outil tiers développé indépendamment.  
L'auteur de ce dépôt n'est pas affilié aux fabricants de cartes mères ni à AMI.  
Toute modification est effectuée **à vos risques et périls**.
