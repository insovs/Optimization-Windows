# 🔍 Autoruns — Sysinternals (Official from Microsoft)

**L'outil de référence pour auditer, optimiser, nettoyer et sécuriser tout ce qui démarre avec Windows.**

Autoruns est un outil **gratuit et officiel de Microsoft** (suite Sysinternals), créé par Mark Russinovich. Le Gestionnaire des tâches et MSCONFIG ne montrent qu'une infime partie de la réalité — Autoruns, lui, expose **absolument tout** : clés de registre cachées, extensions shell, pilotes, tâches planifiées, DLLs injectées, fournisseurs Winsock, et bien plus encore.

> C'est l'outil qu'utilisent aussi bien les power users pour optimiser leur PC que les experts en cybersécurité pour traquer des malwares persistants.

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
