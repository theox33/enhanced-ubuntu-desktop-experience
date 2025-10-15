# Changelog

## Version 2.2.2 (15 octobre 2025)

### 🛡️ Nouvelle fonctionnalité : Détection d'installation existante

- **Prévention de double installation**
  - Le script détecte automatiquement si Enhanced Ubuntu est déjà installé
  - Empêche l'option "Installer" (menu option 1) si déjà présent
  - Bloque `./install.sh --install` avec message d'erreur explicatif
  - Affiche les composants détectés (fond d'écran, thème, icônes, curseurs, polices)

- **Critères de détection**
  - Vérification de 5 indicateurs clés :
    1. Fond d'écran personnalisé (`~/.local/share/backgrounds/enhanced-ubuntu-wallpaper.png`)
    2. Thème Lavanda dans `~/.themes/`
    3. Icônes Uos dans `~/.icons/`
    4. Curseurs Bibata dans `~/.icons/`
    5. Police Comfortaa dans `~/.local/share/fonts/`
  - Seuil : 3+ indicateurs présents = installation détectée

- **Guidage utilisateur amélioré**
  - Instructions claires pour réinstaller (d'abord `--remove`, puis `--install`)
  - Affichage visuel dans le menu (option 1 grisée avec "[DÉJÀ INSTALLÉ]")
  - Message informatif au démarrage si détection positive
  - Liste des composants détectés en mode ligne de commande

### 🔧 Améliorations de l'activation des extensions

- **Validation stricte des extensions installées**
  - Vérification que `metadata.json` existe avant de marquer comme installée
  - Échec de compilation des schémas = suppression de l'extension
  - Nettoyage automatique des extensions invalides ou corrompues

- **Activation intelligente**
  - Suivi des extensions installées avec succès uniquement
  - Configuration via gsettings pour activation au prochain login
  - Plus de tentatives d'activation durant l'installation (ne fonctionne pas)
  - Abandon de `gnome-extensions enable` (pas fiable pendant l'installation)

- **Meilleurs messages utilisateur**
  - "Configurées pour activation" au lieu de "activées"
  - Instructions claires : déconnexion/reconnexion requise
  - Commande de vérification fournie : `gnome-extensions list --enabled`

### 🎨 Améliorations visuelles

- **Nouvelles couleurs ajoutées**
  - `DIM` (texte grisé) pour l'option désactivée
  - `BOLD` (texte gras) pour les accents importants
  - Meilleure hiérarchie visuelle dans les messages

### 📝 Documentation

- Ajout de `DETECTION-INSTALLATION.md` - Documentation complète de la détection
- Mise à jour de `README.md` avec section sur la détection
- Mise à jour de `CHANGELOG.md` avec détails complets

---

## Version 2.2.0 (15 octobre 2025)

### 🎉 Nouvelles fonctionnalités majeures

- **Menu interactif principal**
  - Menu au démarrage avec 5 options : Installer, Restaurer défauts, Backup, Restore, Quitter
  - Navigation simple et intuitive
  - Affichage uniquement si aucune option en ligne de commande

- **Fond d'écran personnalisé intégré** 🖼️
  - Image encodée en base64 directement dans le script (3.4 MB)
  - Pas de fichier externe nécessaire
  - Installation automatique vers `~/.local/share/backgrounds/`
  - Application automatique avec gsettings pour mode clair et sombre
  - Option de zoom optimale

- **Restauration des paramètres par défaut Ubuntu**
  - Nouvelle option `--remove` pour revenir à l'état par défaut
  - Désactive toutes les extensions personnalisées
  - Réactive les extensions Ubuntu (ubuntu-dock, tiling-assistant, etc.)
  - Restaure tous les thèmes, icônes, curseurs et polices par défaut
  - **Option de suppression complète** : Demande si l'utilisateur veut supprimer tous les fichiers installés
  - Suppression sélective : thèmes, icônes, polices, extensions, fond d'écran
  - Mode interactif avec confirmation avant suppression
  - Conservation des packages système (apt) par défaut

- **Nouvelles options en ligne de commande**
  - `--install` : Installation directe sans menu
  - `--remove` : Restaurer les paramètres Ubuntu par défaut
  - `--backup` : Créer uniquement un backup
  - `--restore` : Restaurer depuis un backup précédent

- **Activation automatique des extensions GNOME** ✨
  - Les extensions s'activent maintenant **automatiquement** après installation
  - Pause de 2 secondes pour permettre la détection par GNOME Shell
  - Vérification que chaque extension est installée avant activation
  - Compteur d'extensions activées avec succès
  - Liste des extensions qui nécessitent un redémarrage
  - Rechargement forcé de la liste via busctl

### 🔧 Améliorations

- **Installation du fond d'écran robuste** 🛡️
  - Vérification que le script existe avant extraction
  - Détection automatique du marqueur `__WALLPAPER_DATA__`
  - Messages d'erreur détaillés si le script est déplacé/corrompu
  - Fallback intelligent si `readlink -f` échoue
  - Logging du nombre d'octets extraits pour diagnostic
  - Suppression automatique des fichiers vides en cas d'échec

- **Redémarrage GNOME Shell amélioré**
  - Méthode busctl en priorité (plus fiable)
  - Fallback sur killall si busctl échoue
  - Instructions manuelles si tout échoue
  - Messages adaptés selon X11/Wayland

- **Restauration de backup enrichie**
  - Restaure maintenant aussi les extensions activées
  - Lit le fichier `enabled-extensions.txt` du backup
  - Désactive toutes les extensions actuelles avant restauration
  - Liste des backups disponibles en mode interactif

### 🐛 Corrections de bugs

- **Dossier temporaire universel** 🌍
  - Remplacement de `~/Downloads/gnome-config-temp` par `/tmp/gnome-config-temp-$$`
  - Compatible avec toutes les langues (Downloads, Téléchargements, Descargas, etc.)
  - Utilisation de `/tmp` qui existe toujours sur tous les systèmes
  - Ajout du PID (`$$`) pour éviter les conflits entre plusieurs exécutions
  - **Corrige le bug** : "Le script n'existe pas à l'emplacement résolu"

- **Commande `stat` corrigée**
  - Utilisation de `stat -c%s` (Linux) au lieu de `stat -f%z` (BSD/macOS)
  - Compatible avec toutes les distributions Linux

- **Vérification du fichier de fond d'écran**
  - Ajout du test `-s` pour vérifier que le fichier n'est pas vide (0 octets)
  - Prévention de l'application d'un fond d'écran corrompu

### 📝 Documentation

- Ajout de CHANGELOG-v2.2.0.md avec détails complets
- Mise à jour de l'aide (--help) avec nouvelles options
- Exemples d'utilisation pour chaque mode

---

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
