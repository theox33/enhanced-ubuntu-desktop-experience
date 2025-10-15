# Détection d'installation existante

## Vue d'ensemble

À partir de la version 2.2.2, le script détecte automatiquement si Enhanced Ubuntu Desktop est déjà installé sur le système et **empêche une double installation**.

## Comment ça fonctionne

### Indicateurs de détection

Le script vérifie la présence de 5 indicateurs clés :

1. **Fond d'écran personnalisé** : `~/.local/share/backgrounds/enhanced-ubuntu-wallpaper.png`
2. **Thème Lavanda** : Dossiers dans `~/.themes/` contenant "lavanda"
3. **Icônes Uos** : Dossiers dans `~/.icons/` contenant "uos"
4. **Curseurs Bibata** : Dossiers dans `~/.icons/` contenant "bibata"
5. **Police Comfortaa** : Fichiers dans `~/.local/share/fonts/` contenant "comfortaa"

### Seuil de détection

Si **au moins 3 indicateurs sur 5** sont présents, le système est considéré comme déjà équipé d'Enhanced Ubuntu Desktop.

## Comportement

### Mode interactif (menu)

Lorsque vous lancez `./install.sh` sans arguments :

```
╔════════════════════════════════════════════════════════════════════════╗
║                          MENU PRINCIPAL                                ║
╚════════════════════════════════════════════════════════════════════════╝

ℹ️  Enhanced Ubuntu Desktop est déjà installé sur ce système

1) Installer la configuration GNOME personnalisée [DÉJÀ INSTALLÉ]
2) Restaurer les paramètres par défaut Ubuntu
3) Créer un backup des paramètres actuels
4) Restaurer depuis un backup précédent
5) Quitter

Choisissez une option [1-5]:
```

Si vous choisissez l'option **1** alors que le thème est déjà installé :

```
════════════════════════════════════════════════════════════════════════
⚠️  Enhanced Ubuntu Desktop est déjà installé !
════════════════════════════════════════════════════════════════════════

Pour réinstaller, vous devez d'abord restaurer les paramètres par défaut :
  1. Choisissez l'option 2 (Restaurer les paramètres par défaut)
  2. Relancez le script et choisissez l'option 1 (Installer)

💡 Ou lancez directement : ./install.sh --remove

Appuyez sur Entrée pour revenir au menu...
```

### Mode ligne de commande

Si vous lancez `./install.sh --install` alors que le thème est déjà installé :

```
════════════════════════════════════════════════════════════════════════
⚠️  Enhanced Ubuntu Desktop est déjà installé sur ce système !
════════════════════════════════════════════════════════════════════════

Les composants suivants ont été détectés :
  ✓ Fond d'écran personnalisé
  ✓ Thème Lavanda
  ✓ Icônes Uos
  ✓ Curseurs Bibata
  ✓ Police Comfortaa

Pour réinstaller, restaurez d'abord les paramètres par défaut :
  ./install.sh --remove

Puis relancez l'installation :
  ./install.sh --install
```

Le script se termine avec le code de sortie `1`.

## Processus de réinstallation

### Méthode 1 : Menu interactif

```bash
./install.sh
# Choisir l'option 2 (Restaurer les paramètres par défaut)
# Confirmer la suppression des fichiers si désiré
# Relancer le script
./install.sh
# Choisir l'option 1 (Installer)
```

### Méthode 2 : Ligne de commande

```bash
# Restaurer les défauts
./install.sh --remove

# Réinstaller
./install.sh --install
```

### Méthode 3 : Automatique

```bash
# Tout en une seule commande
./install.sh --remove && ./install.sh --install
```

## Options non affectées

Les options suivantes fonctionnent **même si Enhanced Ubuntu est déjà installé** :

- ✅ `--remove` : Restaurer les paramètres par défaut
- ✅ `--backup` : Créer un backup
- ✅ `--restore` : Restaurer depuis un backup
- ✅ `-d, --dry-run` : Simuler l'installation
- ✅ Menu interactif options 2, 3, 4, 5

Seule l'option `--install` (ou option 1 du menu) est bloquée.

## Avantages

✅ **Prévient les conflits** : Évite d'écraser une installation existante  
✅ **Évite la duplication** : Pas de fichiers en double  
✅ **Guidage clair** : Instructions précises pour réinstaller  
✅ **Sécurité** : Protège contre les installations accidentelles  
✅ **Flexibilité** : Permet la réinstallation en suivant les étapes

## Cas d'usage

### Installation partielle précédente

Si une installation précédente a échoué partiellement (moins de 3 indicateurs), le script **autorise l'installation** car il ne détecte pas de configuration complète.

### Installation manuelle préalable

Si vous avez installé manuellement certains composants (ex: Lavanda, Bibata), et que 3+ indicateurs sont présents, le script **bloquera l'installation** pour éviter les conflits.

Solution : Lancez `--remove` pour nettoyer, puis réinstallez.

## Désactivation (pour les développeurs)

Si vous voulez forcer l'installation malgré la détection, vous pouvez :

1. **Commenter la vérification** dans le script (lignes concernées)
2. **Supprimer manuellement les indicateurs** avant l'installation
3. **Utiliser dry-run** pour tester : `./install.sh -d --install`

Note : Dry-run ignore la vérification d'installation existante.

---

**Version** : 2.2.2  
**Date** : 15 octobre 2025  
**Fonctionnalité** : Détection d'installation existante
