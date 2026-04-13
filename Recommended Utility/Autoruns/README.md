<div align="center">

# 🔍 Autoruns — Sysinternals

**L'outil de référence pour auditer, nettoyer et sécuriser tout ce qui démarre avec Windows.**

[![Sysinternals](https://img.shields.io/badge/Microsoft-Sysinternals-0078D4?style=flat-square&logo=microsoft&logoColor=white)](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns)
[![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D4?style=flat-square&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![Gratuit](https://img.shields.io/badge/Prix-Gratuit-brightgreen?style=flat-square)]()
[![Portable](https://img.shields.io/badge/Type-Portable-orange?style=flat-square)]()

</div>

---

## 🧠 C'est quoi Autoruns ?

Autoruns est un outil **gratuit et officiel de Microsoft** (suite Sysinternals), créé par Mark Russinovich. C'est l'utilitaire **le plus complet qui existe** pour visualiser tout ce qui se lance automatiquement sur Windows — au démarrage, à la connexion, ou en arrière-plan.

Le Gestionnaire des tâches et MSCONFIG ne montrent qu'une infime partie de la réalité. Autoruns, lui, expose **absolument tout** : clés de registre cachées, extensions shell, pilotes, tâches planifiées, DLLs injectées, fournisseurs Winsock, et bien plus encore.

> **En résumé :** si quelque chose démarre avec Windows sans que tu le décides, Autoruns le trouve.

---

## 💪 Pourquoi c'est un outil indispensable ?

| Ce que les autres outils voient | Ce qu'Autoruns voit en plus |
|---|---|
| Dossier Démarrage | Clés Run / RunOnce du registre |
| Liste de démarrage MSCONFIG | Extensions shell Explorer |
| Services visibles | Pilotes noyau (Drivers) |
| — | Tâches planifiées |
| — | AppInit DLLs |
| — | Image Hijacks (détournements de processus) |
| — | Fournisseurs Winsock |
| — | Entrées Winlogon |
| — | Codecs, LSA Providers, Print Monitors... |

Autoruns va **infiniment plus loin** que tout ce que Windows propose nativement. C'est pour ça qu'il est utilisé aussi bien par les power users qui veulent optimiser leur PC que par les experts en cybersécurité qui traquent des malwares.

---

## 📥 Téléchargement & Lancement

1. Télécharge `autoruns.exe` depuis ce dossier **ou** directement depuis [Microsoft Sysinternals](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns)
2. **Pas d'installation** — c'est un outil portable, tu le lances directement
3. Fais un **clic droit → Exécuter en tant qu'administrateur** pour avoir une visibilité complète sur les entrées système

> [!IMPORTANT]
> Sans les droits administrateur, Autoruns ne voit pas les drivers, services système et autres entrées critiques. Toujours le lancer en admin.

---

## ⚙️ Configuration recommandée avant de commencer

Avant d'analyser quoi que ce soit, applique ces deux options dans le menu **Options** :
