# Changelog

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
