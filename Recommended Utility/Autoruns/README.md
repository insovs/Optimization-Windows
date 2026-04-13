
# 🔍 Autoruns Sysinternals (Official from Microsoft)

**L'outil de référence pour auditer, optimise, nettoyer et sécuriser tout ce qui démarre avec Windows.**

Autoruns est un outil **gratuit et officiel de Microsoft** (suite Sysinternals), créé par Mark Russinovich. C'est l'utilitaire **le plus complet qui existe** pour visualiser tout ce qui se lance automatiquement sur Windows — au démarrage, à la connexion, ou en arrière-plan.

Le Gestionnaire des tâches et MSCONFIG ne montrent qu'une infime partie de la réalité. Autoruns, lui, expose **absolument tout** : clés de registre cachées, extensions shell, pilotes, tâches planifiées, DLLs injectées, fournisseurs Winsock, et bien plus encore.

> **En résumé :** il permet de voir tout se qui se lance avec Windows sur la machine.

---

## 💪 Pourquoi c'est un outil indispensable ?

Le Gestionnaire des tâches et MSCONFIG ne montrent qu'une fraction de ce qui démarre réellement sur ton système. Autoruns expose **tout**, dans l'ordre exact où Windows le charge — bien plus que n'importe quel autre outil gratuit.

Voici les principales sections couvertes :

- **Services** — services Windows démarrant automatiquement
- **Drivers** — pilotes noyau enregistrés sur le système
- **Scheduled Tasks** — tâches planifiées au boot ou à intervalles réguliers
- **Boot Execute** — programmes lancés avant même le chargement de Windows
- **Logon** — programmes lancés à la connexion utilisateur
- et bien d'autres emplacements

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
