# Changelog

## Version 2.1.1 (15 octobre 2025)

### 🐛 Corrections de bugs

- **Correction de l'installation des extensions GNOME**
  - Fix du parsing JSON de l'API extensions.gnome.org
  - Utilisation de Python pour parser le JSON (plus robuste)
  - Fallback grep si Python n'est pas disponible
  - Toutes les 12 extensions s'installent maintenant correctement

- **Amélioration de l'installation du thème Lavanda**
  - Suppression du paramètre `-t blue` qui causait une erreur
  - Ajout d'un fallback manuel si le script automatique échoue
  - Copie manuelle des thèmes si nécessaire
  - Installation de tous les variants disponibles en dernier recours

- **Amélioration de la détection du thème**
  - Recherche dans `~/.themes/` ET `/usr/share/themes/`
  - Utilisation de `find` pour une détection robuste
  - Fallback sur le thème Yaru si Lavanda n'est pas trouvé
  - Message plus explicite si le thème n'est pas installé

- **Vérification de la connexion internet**
  - Méthode multi-fallback : wget → curl → ping
  - Utilisation de `8.8.8.8` (IP) au lieu de noms de domaine
  - Évite les problèmes de résolution DNS ou ICMP bloqué

- **Redémarrage automatique de GNOME Shell** (nouveau)
  - Proposition de redémarrer GNOME Shell après installation (mode interactif)
  - Détection automatique X11 vs Wayland
  - Redémarrage automatique sur X11 si l'utilisateur accepte
  - Avertissement pour Wayland (nécessite déconnexion/reconnexion)

### 📝 Documentation

- Suppression de `FEATURES-2.1.md` (contenu redondant avec README.md)
- Simplification de la structure documentaire (3 fichiers MD principaux)

---

## Version 2.1 (15 octobre 2025)

### 🎉 Nouvelles fonctionnalités

- **Mode interactif vs non-interactif**
  - Option `-y, --non-interactive` pour installation automatique
  - Confirmations utilisateur en mode interactif (par défaut)
  - Demandes de confirmation pour chaque étape importante

- **Mode Dry-Run**
  - Option `-d, --dry-run` pour simuler l'installation
  - Aucune modification du système en mode simulation
  - Permet de vérifier ce qui sera installé sans risque

- **Mode verbeux**
  - Option `-v, --verbose` pour afficher plus de détails
  - Messages de débogage pour le diagnostic
  - Informations sur chaque étape détaillée

- **Système de logging**
  - Création automatique d'un fichier de log horodaté
  - Option `--log FILE` pour personnaliser l'emplacement
  - Tous les événements sont enregistrés avec timestamps

- **Vérifications préalables améliorées**
  - Vérification de l'espace disque (minimum 500 MB)
  - Test de la connexion internet avec timeout
  - Vérification des permissions sudo au début
  - Maintien automatique de la session sudo pendant le script

- **Système de backup et restauration**
  - Création automatique d'un backup des paramètres actuels
  - Sauvegarde des paramètres dconf (desktop et shell)
  - Liste des extensions activées avant installation
  - Possibilité de restaurer facilement en cas de problème

- **Amélioration des téléchargements**
  - Vérification de la taille des fichiers téléchargés
  - 3 tentatives de téléchargement en cas d'échec
  - Affichage de la taille des fichiers téléchargés
  - Détection des téléchargements invalides

- **Options de ligne de commande**
  - `--skip-upgrade` : Sauter la mise à niveau système (apt upgrade)
  - `-h, --help` : Affichage de l'aide complète
  - Support de multiples options combinées

- **Rapport final amélioré**
  - Bannière ASCII art au démarrage
  - Statistiques détaillées (extensions installées, erreurs, warnings)
  - Information sur l'emplacement du fichier de log
  - Message sur le backup créé
  - Distinction visuelle entre dry-run et installation réelle

### 🔧 Améliorations techniques

- Comptage des extensions installées avec succès
- Comptage des fichiers de polices installés
- Meilleure gestion des processus sudo (keep-alive)
- Détection automatique de la version complète de GNOME
- Vérification de chaque paquet avant installation
- Messages de débogage contextuels en mode verbose

### 📊 Amélioration UX

- Banner ASCII art au démarrage
- Code couleur amélioré (ajout de CYAN et MAGENTA)
- Messages dry-run clairement identifiés
- Progression plus visible avec compteurs
- Aide complète avec exemples d'utilisation

### 🐛 Corrections

- Meilleure gestion des timeouts de téléchargement
- Vérification de la validité des archives téléchargées
- Nettoyage amélioré en cas d'erreur
- Kill du processus sudo keeper à la fin

---

## Version 2.0 (15 octobre 2025)

### 🎉 Améliorations majeures

- **Réécriture complète de l'installation des extensions GNOME**
  - Utilise maintenant l'API officielle extensions.gnome.org
  - Détection automatique de la version de GNOME Shell
  - Téléchargement et installation corrects des extensions
  - Compilation automatique des schémas GSettings

- **Gestion d'erreurs robuste**
  - Suppression de `set -e` trop strict
  - Compteurs d'erreurs et d'avertissements
  - Le script continue même en cas d'erreur non-critique
  - Rapport final détaillé

- **Vérifications et validations**
  - Vérification de la connexion internet au démarrage
  - Détection de la version de GNOME Shell
  - Vérification de l'existence des fichiers téléchargés
  - Timeouts sur tous les téléchargements wget (30s)

- **Détection automatique intelligente**
  - Fallback automatique pour les noms de thèmes
  - Détection des noms de curseurs après extraction
  - Recherche des polices dans toute l'arborescence

- **Nouveaux outils installés**
  - `curl` pour les requêtes API
  - `libglib2.0-dev-bin` pour `glib-compile-schemas`

### 🔧 Corrections de bugs

- Correction de l'installation des extensions (critique)
- Meilleure gestion des erreurs de téléchargement
- Vérification des chemins de thèmes avant application
- Gestion des variantes de noms (Bibata-Modern-Ice vs Bibata-Modern-Ice-Right)

### 📊 Améliorations UX

- Messages plus clairs et informatifs
- Rapport final avec statistiques d'erreurs
- Instructions de dépannage incluses dans le message final
- Utilisation de `2>/dev/null` pour réduire le bruit

---

## Version 1.0 (15 octobre 2025)

### 🎉 Version initiale

- Installation automatisée de la configuration GNOME personnalisée
- Téléchargement et installation des polices (Comfortaa, JetBrains Mono)
- Installation des thèmes (Lavanda-Sea)
- Installation des icônes (Uos-fulldistro-icons)
- Installation des curseurs (Bibata-Modern-Ice)
- Tentative d'installation des extensions GNOME (non fonctionnelle)
- Configuration de Burn My Windows
- Application des paramètres via gsettings

### ⚠️ Problèmes connus (corrigés en v2.0)

- L'installation des extensions GNOME ne fonctionnait pas
- `set -e` causait des arrêts prématurés
- Pas de vérification de version GNOME
- Pas de rapport d'erreurs détaillé
